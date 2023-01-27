require("charlie")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qall qall
    cnoreabbrev Qa qa
    cnoreabbrev qA qa

    " remove trailing whitespaces
    command! FixWhitespace :%s/\s\+$//e
    " Format JSON using jq
    command! JsonFmt :%!jq '.'

    augroup vimrc-remember-cursor-position
      autocmd!
      autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    if has('macunix')
      " pbcopy for OSX copy/paste
      vmap <C-x> :!pbcopy<CR>
      vmap <C-c> :w !pbcopy<CR><CR>
    endif
]])
