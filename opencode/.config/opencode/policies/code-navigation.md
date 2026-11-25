# Code navigation

- Use Glob for paths and the dedicated Grep tool for text; it uses ripgrep. Use shell `rg` only when appropriate and permitted by the active tool instructions.
- For syntax-shaped searches, consider `ast-grep run --custom-languages ignore` with an explicit language and pattern, only when shell file search is allowed and the command is permitted. Use search only; do not use rewrite or update options. Otherwise fall back to the available search tools. Structural matches are not semantic references.
- When an LSP navigation tool is actually available and working, use it for definitions, references and symbol navigation when useful. LSP configuration alone does not guarantee that tool exists. Trust only appropriate language servers and project configuration; fall back to search if unavailable or unreliable.
- Navigation results do not replace reading relevant code or running appropriate checks. Existing tool, path and edit permissions always apply; do not bypass denials.
