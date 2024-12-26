require("lspconfig").ts_ls.setup({
	capabilities = require("charlie.lsp.capabilities"),
	on_attach = require("charlie.lsp.attach"),
})
