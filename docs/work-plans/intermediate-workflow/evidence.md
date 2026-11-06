# Implementation evidence (reviews pending)

2026-11-06. Worktree `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev`, branch `planned-dev`, starting HEAD `10cea7b` (red tests), parent `c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44`. Ruby `2.6.10p210` universal.arm64e-darwin26. All commands below run from the worktree root, against the uncommitted implementation snapshot identified by SHA-256 below. No infrastructure target or deployment involved.

## Checks

- `ruby opencode/.config/opencode/evals/check_planned_dev.rb` — exit 0; 29/29 passed.
- `ruby opencode/.config/opencode/evals/check_delivery_workflow.rb` — exit 1; 96/98 passed. Failures: `ticket-orchestrator: permissions unchanged`, `developer-personal: permissions unchanged`. Identical to the supplied pre-existing baseline (96/98, same snapshots); delta 0. Neither agent's permissions were changed here. Not a green suite.
- `ruby opencode/.config/opencode/evals/check_quick_dev.rb` — exit 0; policy checks passed.
- `ruby opencode/.config/opencode/evals/check_shared_access.rb` — exit 0; shared access checks passed.
- `ruby opencode/.config/opencode/evals/check_infra_policy.rb` — exit 0; infrastructure policy checks passed.
- `ruby -c opencode/.config/opencode/evals/check_planned_dev.rb` — exit 0; Syntax OK.
- `ruby -r yaml -r json -e 'ARGV.each { |f| YAML.safe_load(File.read(f).split(/^---\s*$\n?/,3)[1]); puts "YAML OK #{f}" }; JSON.parse(File.read("opencode/.config/opencode/opencode.json")); puts "JSON OK opencode/.config/opencode/opencode.json"' opencode/.config/opencode/agents/planned-dev.md opencode/.config/opencode/agents/quick-dev.md opencode/.config/opencode/agents/feature-developer.md opencode/.config/opencode/agents/ticket-orchestrator.md` — exit 0; all four YAML frontmatters and JSON parsed.
- Build and separate lint: not applicable to prompt/policy changes; syntax and static contract checks above are the applicable validation.
- `git diff --cached --check` — exit 2: three Markdown hard-break trailing spaces in immutable `brief-v2.md` lines 3–5; retained to preserve its approved digest. The same check scoped to all other staged task paths exited 0.

Snapshot hashes (`shasum -a 256`, exit 0):

```text
c6426877a2929cac7e96d5b37bc84292a0f29ebf7eb19c9c0f57956384ab087c  opencode/.config/opencode/agents/planned-dev.md
c152de49040995e5c63627672c8ceeaf017aee5aa6f339367b93e402ceb58919  opencode/.config/opencode/agents/quick-dev.md
852279d4847065d5217883dcc59afd3075367014e9f72358b10350893dc8f6c3  opencode/.config/opencode/agents/feature-developer.md
d8cc26b1ea0d5f8aea70e065cd248feeecab00f67a700b7c9db8a2ccd56bfe6e  opencode/.config/opencode/agents/ticket-orchestrator.md
d7611a1d98349273d455f983ee0409a6a76939688347d9afa7e34f4a3ec2b8d0  opencode/.config/opencode/policies/delivery-brief.md
fc3cf6be04b9a8c129be2fa2077904ec57072b51695791e65aec1b46b7097421  opencode/.config/opencode/evals/README.md
d09b9115052bd3c37acdfd9a15360a316227c6cc3c003bf23355ddd4ea528471  opencode/.config/opencode/evals/check_planned_dev.rb
```

## AC mapping

1–3: `agents/planned-dev.md` — request authority, internal plan, delegated tests, risk review, bounded repairs.
4: `agents/quick-dev.md`, `agents/ticket-orchestrator.md` — manual routing, unchanged default and task permissions.
5–6: `agents/feature-developer.md`, `policies/delivery-brief.md`, `agents/ticket-orchestrator.md` — test modes, explicit action authority, snapshot handoff and supplied-brief gates.
Static assertions: `evals/check_planned_dev.rb` and `evals/README.md`. Approved immutable content and lifecycle binding: `brief-v2.md`, `README.md`, `source-request.md`.

## Limitations

Model evals and runtime permission enforcement are deferred, not passed. Static checks cannot prove autonomous behavior, runtime denial or shell isolation. Independent security, deep code and completion reviews remain pending; this is not a completion verdict. Restart OpenCode to load changed agent configuration.
