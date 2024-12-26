local null_ls = require("null-ls")

null_ls.setup({
	timeout_ms = 1000,
	capabilities = require("charlie.lsp.capabilities"),
	debug = false,
	on_attach = require("charlie.lsp.attach"),
	sources = {
		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Go
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,

		-- JS
		null_ls.builtins.formatting.prettier,

		-- Protos
		null_ls.builtins.formatting.buf,
	},
})
