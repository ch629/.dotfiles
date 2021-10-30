local telescope = require'telescope'

telescope.load_extension('fzy_native')

telescope.setup {
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
