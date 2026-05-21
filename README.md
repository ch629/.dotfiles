# Dot Files

## Prerequisites
* Install relies on [GNU Stow](https://www.gnu.org/software/stow/)
* [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
* zsh-syntax-highlighting:
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
* [Delta](https://github.com/dandavison/delta) for git diff
* [Kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator

## Usage
Run the install file to create symlinks to each folder in this repo.

## OpenCode agent guidance

When using the OpenCode agents in `opencode/.config/opencode/agents`:

- Use `go-financial-code-reviewer` for high-risk Go and financial logic reviews (currency math, settlement, idempotency, correctness, Go style/100go).
- Use `database-admin-reviewer` for data-layer reviews (schema design, migration safety, query/hot-path performance, data integrity, and operational DB risk).
- Use both when a change spans Go financial logic and DB design/performance concerns.
