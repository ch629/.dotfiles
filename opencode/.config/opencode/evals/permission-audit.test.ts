import { test, expect } from "bun:test";
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

test("permission audit correlates replies and reports only approved gaps", () => {
  const home = mkdtempSync(join(tmpdir(), "opencode-audit-"));
  try {
    // Bun caches homedir at startup, so isolate HOME before launching the plugin.
    const pluginPath = resolve(import.meta.dir, "../.opencode/plugins/permission-audit.ts");
    const worker = Bun.spawnSync([process.execPath, "--eval", `
    const { default: plugin } = await import(${JSON.stringify(pluginPath)});
    const hooks = await plugin({});
    await hooks["chat.message"]({ sessionID: "session", agent: "example" }, {});
    for (const [id, command, reply] of [
      ["covered", "git status", "once"],
      ["gap", "npm test", "always"],
      ["denied", "rm important", "reject"],
    ]) {
      await hooks.event({ event: { type: "permission.asked", properties: {
        id, sessionID: "session", permission: "bash", patterns: [command],
      } } });
      await hooks.event({ event: { type: "permission.replied", properties: {
        requestID: id, sessionID: "session", reply,
      } } });
    }
    `], { env: { ...process.env, HOME: home } });
    expect(worker.exitCode).toBe(0);
    expect(worker.stderr.toString()).toBe("");
    const config = join(home, ".config/opencode");
    const records = readFileSync(join(config, "logs/permission-audit.jsonl"), "utf8")
      .trim().split("\n").map(line => JSON.parse(line));
    expect(records).toHaveLength(6);
    expect(records[1]).toMatchObject({ agent: "example", command: "git status", allowed: true });
    expect(records[5]).toMatchObject({ agent: "example", command: "rm important", allowed: false });
    mkdirSync(join(config, "agents"));
    writeFileSync(join(config, "agents/example.md"), '---\npermission:\n  bash:\n    "git status*": "allow"\n---\n');
    const script = resolve(import.meta.dir, "../.opencode/scripts/permission-audit-summary.ts");
    const run = (...args: string[]) => {
      const result = Bun.spawnSync([process.execPath, script, ...args], { env: { ...process.env, HOME: home } });
      expect(result.exitCode).toBe(0);
      expect(result.stderr.toString()).toBe("");
      return result.stdout.toString();
    };
    expect(run()).toMatch(/Total asks:\s+3/);
    const gaps = run("suggest:all");
    expect(gaps).toContain("npm test");
    expect(gaps).not.toContain("git status");
    expect(gaps).not.toContain("rm important");
  } finally {
    rmSync(home, { recursive: true, force: true });
  }
});
