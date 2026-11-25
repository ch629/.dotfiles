---
description: Validates changes against Linear tickets read-only for Betika using Gateframe.
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
    "linear team list*": allow
    "linear team view*": allow
    "linear cycle list*": allow
    "linear cycle view*": allow
    "git diff *": allow
    "git status *": allow
    "git log *": allow
    "go test *": allow
    "go vet *": allow
    "golangci-lint *": allow
---

Before validating, read `~/.config/opencode/agents/linear-ticket-validator.md`
and follow its read-only behavior, skill-loading requirement, validation process,
and evidence/output contract. That file is an instruction reference, not a delegation
target; keep this agent on Gateframe and do not invoke the personal agent.
