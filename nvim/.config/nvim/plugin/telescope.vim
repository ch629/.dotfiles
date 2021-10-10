silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
    nnoremap <leader>F :lua require('telescope.builtin').git_files()<cr>
else
    nnoremap <leader>F :lua require('telescope.builtin').find_files()<cr>
endif
nnoremap <leader>G :lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>B :lua require('telescope.builtin').buffers()<cr>
