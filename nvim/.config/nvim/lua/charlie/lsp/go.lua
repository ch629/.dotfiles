require'lspconfig'.gopls.setup {
    capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                fieldalignment = true,
            }
        },
    },
}
