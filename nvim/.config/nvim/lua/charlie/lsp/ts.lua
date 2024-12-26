require("lspconfig").ts_ls.setup({
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    on_attach = require("charlie.lsp.attach"),
})
