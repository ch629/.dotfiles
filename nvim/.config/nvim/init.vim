" Load custom lua
" TODO: Temp until this is fully replaced with lua
lua require("charlie")

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
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

"*****************************************************************************
"" Commands
"*****************************************************************************
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e
" Format JSON using jq
command! JsonFmt :%!jq '.'

" LSP
command! Implements :lua require("telescope.builtin").lsp_implementations()<CR>
command! References :lua require("telescope.builtin").lsp_references()<CR>
command! Callers :References
command! Rename :lua vim.lsp.buf.rename()<CR>

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"*****************************************************************************
"" Mappings
"*****************************************************************************

" ale
let g:ale_linters = {}

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Resize splits
nnoremap <S-Up> :res +5<CR>
nnoremap <S-Down> :res -5<CR>
nnoremap <S-Left> :vertical resize -5<CR>
nnoremap <S-Right> :vertical resize +5<CR>

"" Terminal
tnoremap <Esc> <C-\><C-n>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" Auto pairs
let g:AutoPairsMultilineClose = 0

if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif
