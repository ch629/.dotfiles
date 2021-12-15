require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "comment",
        "go",
        "gomod",
        "json",
        "yaml",
        "bash",
        "vim",
        "lua",
    },
}
