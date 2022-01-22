local g = vim.g

g.go_def_mode = "gopls"
g.go_def_mod_mode = "godef"

-- Commands
-- Swapping between test and code files
vim.cmd("command! -bang A call go#alternate#Switch(<bang>0, 'edit')")
vim.cmd("command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')")
vim.cmd("command! -bang AS call go#alternate#Switch(<bang>0, 'split')")
vim.cmd("command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')")
