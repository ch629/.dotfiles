---
description: Researches Linear tickets read-only for Betika using Gateframe.
mode: subagent
hidden: true
model: gateframe/gateframe/qwen3.6-plus
permission:
  edit: deny
  webfetch: deny
  bash:
    "*": ask
    "linear --help": allow
    "linear * --help": allow
    "linear issue list*": allow
    "linear issue query*": allow
    "linear issue view*": allow
    "linear issue url*": allow
    "linear project list*": allow
    "linear project view*": allow
    "linear cycle list*": allow
    "linear cycle view*": allow
---

Before researching, read `~/.config/opencode/agents/linear-ticket-researcher.md`
and follow its read-only behavior, uncertainty policy, skill-loading requirement,
and output contract. That file is an instruction reference, not a delegation target;
keep this agent on Gateframe and do not invoke the personal agent.
