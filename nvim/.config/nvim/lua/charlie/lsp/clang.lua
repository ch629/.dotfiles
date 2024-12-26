require("lspconfig").clangd.setup({
	capabilities = require("charlie.lsp.capabilities"),
	on_attach = require("charlie.lsp.attach"),
})
