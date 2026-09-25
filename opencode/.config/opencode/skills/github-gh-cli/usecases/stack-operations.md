# Use-case: Stack Operations (`gh stack`)

`gh stack` is a built-in GitHub CLI extension for creating and managing stacked PRs — a chain of branches/PRs that build on each other.

## Prerequisites

- `gh stack` ships with recent `gh` versions. Verify: `gh stack --help`.
- Auth and repo context must be valid (`gh auth status`, `gh repo view`).

## Command reference

### Lifecycle

| Goal | Command |
|------|---------|
| Start a new stack targeting default branch | `gh stack init` |
| Turn existing branches into a stack | `gh stack init branch1 branch2 branch3` |
| Add a branch on top of current stack | `gh stack add <branch>` |
| Push branches + create/update PRs | `gh stack submit` |
| View current stack | `gh stack view` |
| Interactively restructure | `gh stack modify` |
| Remove stack locally and on GitHub | `gh stack unstack` |

### Remote operations

| Goal | Command |
|------|---------|
| Push active branches to remote | `gh stack push` |
| Rebase stack of branches | `gh stack rebase` |
| Sync local stack with remote | `gh stack sync` |
| Merge the full stack | `gh stack merge` |
| Link existing PRs into a stack (no local tracking) | `gh stack link` |

### Navigation

| Goal | Command |
|------|---------|
| Checkout by stack #, PR #, URL, or branch | `gh stack checkout <ref>` |
| Go up the stack (further from trunk) | `gh stack up` |
| Go down the stack (closer to trunk) | `gh stack down` |
| Jump to top branch | `gh stack top` |
| Jump to bottom branch | `gh stack bottom` |
| Jump to trunk | `gh stack trunk` |
| Interactively switch branches | `gh stack switch` |

## Typical workflow

```bash
# 1. Init stack on default branch
gh stack init

# 2. Work on a feature slice, commit, then add next branch
gh stack add feature/part-2

# 3. Push all branches and open PRs
gh stack submit

# 4. After review, keep in sync
gh stack sync

# 5. Merge when approved
gh stack merge
```

## Safety rules

- `gh stack unstack` removes the stack locally **and** on GitHub — confirm intent before running.
- `gh stack merge` merges all PRs in the chain; preview with `gh stack view` first.
- Prefer `gh stack submit` over manual `gh pr create` for stacked branches — it sets the correct base PR automatically.
- After rebasing trunk, run `gh stack rebase` then `gh stack submit` to update all PR bases.

## Discovery

If a subcommand behaves unexpectedly, re-check its flags:

```bash
gh stack <command> --help
```
