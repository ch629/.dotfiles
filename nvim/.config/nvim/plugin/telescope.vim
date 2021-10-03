"" Telescope
nnoremap <leader>F <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <leader>G <cmd>lua require('telescope.builtin').live_grep()<cr>

lua << EOF
require('telescope').load_extension('fzy_native')
EOF
