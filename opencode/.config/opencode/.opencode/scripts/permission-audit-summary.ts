#!/usr/bin/env bun
/**
 * Permission Audit Summary CLI
 *
 * bun run ~/.config/opencode/.opencode/scripts/permission-audit-summary.ts
 * bun run ~/.config/opencode/.opencode/scripts/permission-audit-summary.ts suggest [agent-file]
 * bun run ~/.config/opencode/.opencode/scripts/permission-audit-summary.ts suggest:full [agent-file]
 * bun run ~/.config/opencode/.opencode/scripts/permission-audit-summary.ts suggest:all
 */

import { readFileSync, existsSync, readdirSync } from "node:fs";
import { homedir } from "node:os";
import { join, basename } from "node:path";

const LOG_FILE = join(homedir(), ".config", "opencode", "logs", "permission-audit.jsonl");
const AGENT_DIR = join(homedir(), ".config", "opencode", "agents");

// ── Parse JSONL ──────────────────────────────────────────────────────────

function parseLog() {
  if (!existsSync(LOG_FILE)) return { asks: new Map(), replies: [] as any[] };

  const lines = readFileSync(LOG_FILE, "utf-8").trim().split("\n").filter(Boolean);
  const asks = new Map<string, any>();
  const replies: any[] = [];

  for (const line of lines) {
    try {
      const r = JSON.parse(line);
      if (r.event === "ask") asks.set(r.permissionID, r);
      else if (r.event === "reply") replies.push(r);
    } catch { /* skip malformed lines */ }
  }

  return { asks, replies };
}

// ── Parse agent markdown frontmatter ─────────────────────────────────────

function parseAgentFrontmatter(filePath: string) {
  const raw = readFileSync(filePath, "utf-8");
  const m = raw.match(/^---\n([\s\S]*?)\n---/);
  if (!m) return { permissions: {} };

  // ponytail: naive line-based parse, no yaml dep needed
  const permissions: Record<string, string[]> = {};
  const lines = m[1].split("\n");
  let currentTool: string | null = null;
  for (const line of lines) {
    const toolMatch = line.match(/^  (\w+):/);
    const patternMatch = line.match(/^    "(.+?)":\s*"(.+?)"/);
    if (toolMatch) {
      currentTool = toolMatch[1];
      if (!permissions[currentTool]) permissions[currentTool] = [];
    } else if (patternMatch && currentTool) {
      permissions[currentTool].push(patternMatch[1]);
    }
  }

  return { permissions };
}

// ── Agent name from file path ─────────────────────────────────────────────

function agentNameFromPath(filePath: string): string {
  return basename(filePath, ".md");
}

// ── Coverage check ────────────────────────────────────────────────────────

// ponytail: simple glob-ish match — checks if cmd starts with pattern prefix (trimming *)
function isCovered(cmd: string, patterns: string[]): boolean {
  return patterns.some(p => {
    const base = p.endsWith("*") ? p.slice(0, -1) : p;
    return cmd.startsWith(base);
  });
}

// ── Summary ──────────────────────────────────────────────────────────────

function cmdSummary() {
  const { replies } = parseLog();

  const byAgent = new Map<string, { total: number; allowed: number; denied: number; commands: string[] }>();

  for (const r of replies) {
    const agent = r.agent ?? "unknown";
    if (!byAgent.has(agent)) byAgent.set(agent, { total: 0, allowed: 0, denied: 0, commands: [] });
    const s = byAgent.get(agent)!;
    s.total++;
    if (r.allowed) s.allowed++;
    else s.denied++;
    if (r.command) s.commands.push(r.command);
  }

  console.log("\nPermission Audit Summary\n" + "=".repeat(40));
  for (const [agent, stats] of byAgent) {
    console.log(`\n${agent}`);
    console.log(`  Total asks:      ${stats.total}`);
    console.log(`  Allowed:         ${stats.allowed} (${Math.round(stats.allowed / stats.total * 100)}%)`);
    console.log(`  Denied:          ${stats.denied} (${Math.round(stats.denied / stats.total * 100)}%)`);
    if (stats.commands.length) {
      const distinct = [...new Set(stats.commands)];
      console.log(`  Commands not in allowlist:`);
      for (const c of distinct) {
        const count = stats.commands.filter(x => x === c).length;
        console.log(`    → ${c} (${count}x)`);
      }
    }
  }
}

// ── Suggest for one agent ─────────────────────────────────────────────────

function suggestForAgent(agentPath: string, replies: any[], full: boolean): boolean {
  const agentName = agentNameFromPath(agentPath);
  const { permissions } = parseAgentFrontmatter(agentPath);

  // Filter replies to this agent only
  const agentReplies = replies.filter(r => (r.agent ?? "unknown") === agentName);
  if (!agentReplies.length) return false;

  // Group allowed commands by tool
  const allowed = new Map<string, Map<string, { count: number; responses: string[] }>>();
  for (const r of agentReplies) {
    if (!r.allowed || !r.command) continue;
    const tool = r.tool ?? "bash";
    if (!allowed.has(tool)) allowed.set(tool, new Map());
    const cmds = allowed.get(tool)!;
    if (!cmds.has(r.command)) cmds.set(r.command, { count: 0, responses: [] });
    cmds.get(r.command)!.count++;
    cmds.get(r.command)!.responses.push(r.response);
  }

  // Find uncovered commands per tool
  let hasGaps = false;
  const toolOutput: string[] = [];
  for (const [tool, cmds] of allowed) {
    const existing = permissions[tool] ?? [];
    const candidates = [...cmds.entries()].filter(([cmd]) => !isCovered(cmd, existing));
    if (!candidates.length) continue;

    hasGaps = true;
    toolOutput.push(`  Tool: ${tool}`);
    for (const [cmd, info] of candidates) {
      toolOutput.push(`    Command:   ${cmd}`);
      toolOutput.push(`    Approved:  ${info.count}x`);
      if (full) {
        toolOutput.push(`    Responses: ${info.responses.join(", ")}`);
        const suggested = cmd.replace(/ .*$/, "") + " *";
        toolOutput.push(`    Suggested: "${suggested}": allow`);
      }
      toolOutput.push("");
    }
  }

  if (!hasGaps) return false;

  console.log(`\n${"=".repeat(50)}`);
  console.log(`Agent: ${agentName}`);
  console.log(`File:  ${agentPath}`);
  console.log("=".repeat(50));
  console.log(toolOutput.join("\n"));
  return true;
}

// ── Suggest (single agent) ────────────────────────────────────────────────

function cmdSuggest(agentFile?: string, full = false) {
  const { replies } = parseLog();
  if (!replies.length) {
    console.log("No permission history found.");
    return;
  }

  let agentPath = agentFile;
  if (!agentPath) {
    const defaults = [join(AGENT_DIR, "developer-personal.md"), join(AGENT_DIR, "default.md")];
    agentPath = defaults.find(f => existsSync(f));
  }
  if (!agentPath || !existsSync(agentPath)) {
    console.log("No agent file found. Pass path: suggest /path/to/agent.md");
    return;
  }

  const found = suggestForAgent(agentPath, replies, full);
  if (!found) console.log(`No uncovered commands for ${agentNameFromPath(agentPath)}.`);
}

// ── Suggest all agents ────────────────────────────────────────────────────

function cmdSuggestAll(full = false) {
  const { replies } = parseLog();
  if (!replies.length) {
    console.log("No permission history found.");
    return;
  }

  // Only look at agents that appear in the log
  const agentsInLog = new Set(replies.map(r => r.agent ?? "unknown").filter(a => a !== "unknown"));

  const agentFiles = readdirSync(AGENT_DIR)
    .filter(f => f.endsWith(".md"))
    .map(f => join(AGENT_DIR, f))
    .filter(f => agentsInLog.has(agentNameFromPath(f)));

  if (!agentFiles.length) {
    console.log("No agent files match log entries.");
    return;
  }

  console.log(`\nPermission Gap Report — all agents (${agentFiles.length} with log entries)`);

  let anyGaps = false;
  for (const agentPath of agentFiles.sort()) {
    const found = suggestForAgent(agentPath, replies, full);
    if (found) anyGaps = true;
  }

  if (!anyGaps) console.log("\nAll agents fully covered.");
}

// ── Main ─────────────────────────────────────────────────────────────────

const [, , ...args] = process.argv;

if (args[0] === "suggest:all") {
  cmdSuggestAll(true);
} else if (args[0] === "suggest:full") {
  cmdSuggest(args[1], true);
} else if (args[0] === "suggest") {
  cmdSuggest(args[1], false);
} else {
  cmdSummary();
}
