vim.lsp.config("ts_ls", {
	capabilities = require("charlie.lsp.capabilities"),
	on_attach = require("charlie.lsp.attach"),
})
