require'telescope'.load_extension('fzy_native')

require'telescope'.setup {
    pickers = {
        buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
                i = {
                    ["<c-d>"] = "delete_buffer",
                }
            }
        }
    }
}

return {
    project_files = function()
        local ok = pcall(require'telescope.builtin'.git_files)
        if not ok then require'telescope.builtin'.find_files() end
    end,
}
