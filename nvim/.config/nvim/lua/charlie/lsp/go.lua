require("lspconfig").gopls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				fieldalignment = true,
			},
			staticcheck = true,
			semanticTokens = true,
			codelenses = {
				generate = true,
				gc_details = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = false,
			},
		},
	},
	on_attach = require("charlie.lsp.attach"),
})
