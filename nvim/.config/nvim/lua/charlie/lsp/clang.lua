require("lspconfig").clangd.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = require("charlie.lsp.attach"),
})
