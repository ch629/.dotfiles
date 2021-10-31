local g = vim.g

g.go_list_type = 'quickfix'
g.go_fmt_command = 'gopls'
g.go_gopls_gofumpt = true
g.go_fmt_fail_silently = true
g.go_metalinter_command = 'golangci-lint'
g.go_def_mode = 'gopls'
g.go_def_mod_mode = 'godef'

local linters = {
    'bodyclose',
    'gosec',
    'whitespace',
    'unconvert',
    'wrapcheck',
    'revive',
}
g.ale_go_golangci_lint_options = ''
for _, linter in pairs(linters) do
    g.ale_go_golangci_lint_options = g.ale_go_golangci_lint_options .. ' -E ' .. linter
end

g.go_metalinter_enabled = linters
g.ale_go_golangci_lint_package = true
g.ale_linters = {
    go = {'golangci-lint'},
}

-- Commands
-- Swapping between test and code files
vim.cmd("command! -bang A call go#alternate#Switch(<bang>0, 'edit')")
vim.cmd("command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')")
vim.cmd("command! -bang AS call go#alternate#Switch(<bang>0, 'split')")
vim.cmd("command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')")
