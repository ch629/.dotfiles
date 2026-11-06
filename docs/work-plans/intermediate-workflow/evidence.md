# Implementation and final review evidence

The following initial implementation evidence is historical for the `d48ef40` snapshot, not the later review-fix snapshot documented below.

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

Model evals and runtime permission enforcement are deferred, not passed. Static checks cannot prove autonomous behavior, runtime denial or shell isolation. At the initial snapshot the independent reviews were pending; final verdicts are recorded below. Restart OpenCode after installing changed agent configuration.

## Review-fix cycle 1

On 2026-11-06 the user approved the narrow v3 extension recorded in `brief-v3.md`: reconcile three specialist contracts, strengthen static regressions and narrow write-capable Git allowances. Code review at `d48ef40` identified high-risk specialist snapshot/range incompatibility and an incomplete task-allowlist assertion; security review identified write-capable `git diff*`/`git log*` allowances. At this historical cycle-1 snapshot the fresh reviews were pending; final verdicts follow below.

Worktree `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev`, branch `planned-dev`, starting HEAD `d48ef40`; commands below ran from that root on the candidate source snapshot identified by hashes below. Ruby `ruby 2.6.10p210 (2022-04-12 revision 67958) [universal.arm64e-darwin26]`. No infrastructure execution or target; build and separate lint not applicable to prompt/policy changes.

- Before reviewer and permission fixes, `ruby opencode/.config/opencode/evals/check_planned_dev.rb` exited 1: 39/66 passed, 27 failed (specialist provenance and permission regressions). The exact task map already contained all required entries; its four removal mutations were rejected.
- `ruby opencode/.config/opencode/evals/check_planned_dev.rb && ruby -c opencode/.config/opencode/evals/check_planned_dev.rb && ruby opencode/.config/opencode/evals/check_quick_dev.rb && ruby opencode/.config/opencode/evals/check_shared_access.rb && ruby opencode/.config/opencode/evals/check_infra_policy.rb` — exit 0: 66/66 planned-dev checks passed, Syntax OK, quick-dev/shared-access/infra policy checks passed.
- `ruby opencode/.config/opencode/evals/check_delivery_workflow.rb` — exit 1: 96/98; same pre-existing failures `ticket-orchestrator: permissions unchanged`, `developer-personal: permissions unchanged`, baseline delta 0. Not green.
- `ruby -v && ruby -r yaml -r json -e 'ARGV.each { |f| YAML.safe_load(File.read(f).split(/^---\s*$\n?/,3)[1]); puts "YAML OK #{f}" }; JSON.parse(File.read("opencode/.config/opencode/opencode.json")); puts "JSON OK opencode/.config/opencode/opencode.json"' opencode/.config/opencode/agents/planned-dev.md opencode/.config/opencode/agents/feature-developer.md opencode/.config/opencode/agents/ticket-orchestrator.md opencode/.config/opencode/agents/security-scanner.md opencode/.config/opencode/agents/db-reviewer.md opencode/.config/opencode/agents/migration-reviewer.md && shasum -a 256 opencode/.config/opencode/agents/planned-dev.md opencode/.config/opencode/agents/feature-developer.md opencode/.config/opencode/agents/ticket-orchestrator.md opencode/.config/opencode/agents/security-scanner.md opencode/.config/opencode/agents/db-reviewer.md opencode/.config/opencode/agents/migration-reviewer.md opencode/.config/opencode/evals/check_planned_dev.rb docs/work-plans/intermediate-workflow/brief-v2.md docs/work-plans/intermediate-workflow/brief-v3.md` — exit 0; all six YAML frontmatters and JSON parsed; hashes:

```text
c27a2adaf09f45a5767516d385d3c71a1ef551d8d1c5297a03f0c3ddadee5612  agents/planned-dev.md
6358769c204dc8a49ab792eed9645b53b9aca22d76c17d37f17915c8682e4714  agents/feature-developer.md
a3efc85c4b60c9b6ebbf622f30f910e8266115a04d7c519828f207f0c1d64efa  agents/ticket-orchestrator.md
a8f36da5d712359958c897a8f6b0edf693241381c0c060f049db0cb6dca1f71a  agents/security-scanner.md
0485bf068f62cb91bda22a352c1525318d9e3a95b12e2af2091ee642afa8aa3d  agents/db-reviewer.md
fc2be940c2c7d37c25ea6ec8b66aba3a87ba52213d3f73e1c6d9fc20efb5962d  agents/migration-reviewer.md
e8842692cc853692cf3616202ed53e33c9dbf3c19e6ed60b99f0983af8748c3a  evals/check_planned_dev.rb
b8c4a7052ed567a9ea58dcf247370e5dc746ae975c29c6876d1ad2182a05d627  docs/work-plans/intermediate-workflow/brief-v2.md
d4efd8331ef8945b620e7b739a37867121c1339dc53870afdd2d77b8407a398d  docs/work-plans/intermediate-workflow/brief-v3.md
```

`agents/` and `evals/` in that listing are relative to `opencode/.config/opencode/`. Reviewer contracts now require range or snapshot provenance, block missing/stale inputs and do not substitute a remote base; caller manifests provide snapshot fields. Static task-map checks require the exact ordered seven-worker map and test removal of each specialist; permission checks exercise `--output` pattern examples but do not prove runtime matching.

Infra residual: `infra-reviewer.md` still explicitly requires an immutable range and scoped diff, while `playbooks/infrastructure.md` permits recording a source tree before a commit but requires immutable base/head SHAs. It is not clearly snapshot-compatible. It was outside the approved three-reviewer extension and was not modified; uncommitted infra review must remain blocked if its provenance contract cannot be satisfied. This is not an infrastructure review or validation result.

## Review-fix cycle 2

Starting HEAD `8379bee`, worktree `/Users/charliehowes/.local/state/opencode/worktrees/dotfiles-planned-dev`, 2026-11-06; Ruby `2.6.10p210`, universal.arm64e-darwin26. Security re-review found HIGH: silent `rg *` permits `--pre` program execution. Removed that allowance in planned-dev, feature-developer, security-scanner, db-reviewer and migration-reviewer; their existing `*` shell fallback remains `ask`. Use the dedicated grep tool for search. No other rights added. Other shell search allowances in these surfaces are `grep *` and `ls *`; neither normally provides ripgrep's program-preprocessor execution option. Shell parsing and actual runtime enforcement were not tested and are not asserted safe by that observation.

Code re-review of cycle 1 approved and noted the infra immutable-range requirements safely block missing provenance. That remains a residual gate, not an unresolved code finding; uncommitted infra support is not claimed. Cycle-2 final re-review outcomes follow below.

Commands from the worktree root, before and after the permission fix:

- Added regressions first: `ruby opencode/.config/opencode/evals/check_planned_dev.rb` — exit 1, 71/86 passed, 15 failed: three rg examples per agent (`--pre` separated, `--pre=` and ordinary invocation potentially using rg configuration).
- `ruby opencode/.config/opencode/evals/check_planned_dev.rb && ruby -c opencode/.config/opencode/evals/check_planned_dev.rb && ruby opencode/.config/opencode/evals/check_quick_dev.rb && ruby opencode/.config/opencode/evals/check_shared_access.rb && ruby opencode/.config/opencode/evals/check_infra_policy.rb` — exit 0; planned-dev 86/86, syntax OK, quick-dev/shared-access/infra static checks passed.
- `ruby opencode/.config/opencode/evals/check_delivery_workflow.rb` — exit 1, 96/98: same baseline failures `ticket-orchestrator: permissions unchanged` and `developer-personal: permissions unchanged`, baseline delta zero.
- `ruby -r yaml -r json -e 'ARGV.each { |f| YAML.safe_load(File.read(f).split(/^---\s*$\n?/,3)[1]); puts "YAML OK #{f}" }; JSON.parse(File.read("opencode/.config/opencode/opencode.json")); puts "JSON OK opencode/.config/opencode/opencode.json"' opencode/.config/opencode/agents/planned-dev.md opencode/.config/opencode/agents/feature-developer.md opencode/.config/opencode/agents/security-scanner.md opencode/.config/opencode/agents/db-reviewer.md opencode/.config/opencode/agents/migration-reviewer.md && shasum -a 256 opencode/.config/opencode/agents/planned-dev.md opencode/.config/opencode/agents/feature-developer.md opencode/.config/opencode/agents/security-scanner.md opencode/.config/opencode/agents/db-reviewer.md opencode/.config/opencode/agents/migration-reviewer.md opencode/.config/opencode/evals/check_planned_dev.rb docs/work-plans/intermediate-workflow/brief-v2.md docs/work-plans/intermediate-workflow/brief-v3.md` — exit 0; all five YAML frontmatters and JSON parsed. Tested source SHA-256:

```text
138f051fcc0db4c341ff74e5b2e2b6974c93bf17b2ea2728b0cad30ef7caf740  agents/planned-dev.md
f0b36c0b2cc739764060d03896d6441c68673d0aec4c315fd9a75ebe47262b46  agents/feature-developer.md
1ea9f5af329913da305c154841562e62559cc821b483b10e0d0035c5215a2968  agents/security-scanner.md
3df13091cf492406d95af1e8b0c8de84947ef0a10f396a19f4a23073ff8559cc  agents/db-reviewer.md
1c2723c60f72970b31695acb9b770ab9ad25d4861fe807492c0bbdb5c0669043  agents/migration-reviewer.md
9e79eb403e1666b5d998258ac820973aabf48df57d8fa0f294876fa016f8e35a  evals/check_planned_dev.rb
```

Paths are relative to `opencode/.config/opencode/`. The same command confirmed v2 and v3 hashes unchanged from cycle 1. The Ruby `File.fnmatch?` check is a static approximation, not proof of effective tool permissions; no executable attack or model tests were run. Build and separate lint are not applicable to these prompt/config changes.

## Final review and local handoff — 2026-11-06

Reviewed source range: `c8c2bcb8fcdec87e8113cc614ed8b3c2aaafad44..b895a3eca8c8b8a5eba1bfae190f92e44a04716f`. Both repair cycles are exhausted. The subsequent closeout commit changes only this evidence record and the lifecycle index; reviewed agents, policy, tests and immutable brief bodies remain unchanged.

- Independent deep code reviewer (`ses_e4debc8feffeDlEaupmuOZgOEE`): **Approve**, no remaining must-fix findings. Reviewed full scope and `8379bee..b895a3e` delta; confirmed scoped working files match HEAD, six cycle-2 source hashes and both brief digests. Required contracts, risk routing, task map and provenance rules remain intact.
- Independent security scanner (`ses_e4debc8eaffeG31KjWSJuFO8Im`): **Pass — static prompt/config security review only**, no required security fixes. Full range reviewed across cycles; final delta rechecked for removal of broad Git/ripgrep allowances. Reviewer did not rerun tests or independently verify evidence hashes. Runtime permission matching, shell parsing and executable attack paths remain unverified.
- Completion reviewer (`ses_e4ddf1d82ffe3E3nZIftf00Giq`): **Complete with Residuals — ready for local user review**. Mapped all v2 AC and v3 additive requirements to paths/static evidence; confirmed immutable hashes and clean reviewed worktree. No must-fix. Requested lifecycle/evidence closeout, fulfilled by this documentation update. Verdict covers local delivery, not PR readiness, deployment safety or runtime enforcement.

Final applicable results: planned-dev **86/86**, quick-dev/shared-access/infra policy, Ruby syntax and YAML/JSON parsing passed as recorded above. Delivery-workflow remains **96/98**, the same two pre-existing permission snapshots, baseline delta zero. It is not a green suite and no unrelated assertions were weakened. Model evals, autonomous model behavior, effective permissions, installation/restart and executable integration/attack testing were not run and are not claimed passed.

Final preservation check from the original repository: `git status --short` reported only `D  zsh/.tokens`; `git status --short --ignored -- zsh/.tokens` reported `D  zsh/.tokens` and `!! zsh/.tokens`. This confirms the staged removal and ignored local file remain present without reading their contents. The original index was never mutated.

Local branch/worktree retained for user manual review. No merge/install, push, PR, release or deployment performed. After accepting and installing the change, quit and restart OpenCode; the currently running session does not hot-reload the new agents or permission rules.
