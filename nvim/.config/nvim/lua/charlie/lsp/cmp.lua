local cmp = require("cmp")

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-o>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),

    sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },

    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
    },

    experimental = {
        ghost_text = true,
    },
})
