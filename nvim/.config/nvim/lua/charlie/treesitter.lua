require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    ensure_installed = {
        "comment",
        "go",
        "gomod",
        "gowork",
        "json",
        "yaml",
        "bash",
        "vim",
        "lua",
        "make",
        "dockerfile",
        "markdown",
    },
}
