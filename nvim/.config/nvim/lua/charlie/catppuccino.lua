require'catppuccino'.setup {
    colorscheme = 'dark_catppuccino',
    integrations = {
        treesitter = true,
        lsp_trouble = true,
        lsp_saga = true,
        telescope = true,
        which_key = true,
        gitgutter = true,
        indent_blankline = {
            enabled = true,
        },
    },
}
