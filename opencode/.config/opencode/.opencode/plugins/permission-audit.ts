import type { Plugin } from "@opencode-ai/plugin";
import { appendFileSync, mkdirSync, existsSync, statSync, renameSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const LOG_DIR = join(homedir(), ".config", "opencode", "logs");
const LOG_FILE = join(LOG_DIR, "permission-audit.jsonl");
const MAX_LOG_SIZE = 1_048_576; // 1MB, rotate if exceeded

// Pending asks keyed by permission ID (matches permission.replied.requestID)
const asks = new Map<
  string,
  {
    ts: string;
    sessionID: string;
    agent: string;
    tool: string;
    command: string;
    title: string;
  }
>();

// Session -> agent mapping built from chat.message events
const sessionAgents = new Map<string, string>();

function ensureLogDir() {
  if (!existsSync(LOG_DIR)) mkdirSync(LOG_DIR, { recursive: true });
}

function writeRecord(data: Record<string, unknown>) {
  // ponytail: rotate log if >1MB. one .bak, no chain.
  if (existsSync(LOG_FILE) && statSync(LOG_FILE).size > MAX_LOG_SIZE) {
    renameSync(LOG_FILE, LOG_FILE + ".bak");
  }
  appendFileSync(LOG_FILE, JSON.stringify(data) + "\n");
}

export default (async () => {
  ensureLogDir();

  return {
    // Build sessionID -> agent mapping from incoming messages
    "chat.message": async (input) => {
      if (input.agent) {
        sessionAgents.set(input.sessionID, input.agent);
      }
    },

    // The permission.ask hook is not emitted by the runtime.
    // Use the event bus instead.
    event: async ({ event }) => {
      if (event.type === "permission.asked") {
        const p = (event as any).properties;
        const agent = sessionAgents.get(p.sessionID) ?? "unknown";
        const command = (p.patterns ?? [p.metadata?.command]).join(", ");

        asks.set(p.id, {
          ts: new Date().toISOString(),
          sessionID: p.sessionID,
          agent,
          tool: p.permission,
          command,
          title: p.metadata?.description ?? command,
        });

        writeRecord({
          event: "ask",
          permissionID: p.id,
          sessionID: p.sessionID,
          agent,
          tool: p.permission,
          command,
          title: p.metadata?.description ?? command,
          timestamp: new Date().toISOString(),
        });
        return;
      }

      if (event.type === "permission.replied") {
        const p = (event as any).properties;
        const ask = asks.get(p.requestID);
        const allowed = p.reply === "once" || p.reply === "always";

        writeRecord({
          event: "reply",
          permissionID: p.requestID,
          sessionID: p.sessionID,
          agent: ask?.agent ?? sessionAgents.get(p.sessionID) ?? "unknown",
          tool: ask?.tool ?? null,
          command: ask?.command ?? null,
          title: ask?.title ?? null,
          response: p.reply,
          allowed,
          timestamp: new Date().toISOString(),
        });

        asks.delete(p.requestID);
      }
    },
  };
}) satisfies Plugin;
