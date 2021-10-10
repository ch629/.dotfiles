"" Telescope
silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
    nnoremap <leader>F <cmd>lua require('telescope.builtin').git_files()<cr>
else
    nnoremap <leader>F <cmd>lua require('telescope.builtin').find_files()<cr>
endif
nnoremap <leader>G <cmd>lua require('telescope.builtin').live_grep()<cr>

lua << EOF
require('telescope').load_extension('fzy_native')
EOF
