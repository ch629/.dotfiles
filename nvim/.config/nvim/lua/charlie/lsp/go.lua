require("lspconfig").gopls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				fieldalignment = false,
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
			annotations = {
				escape = true,
			},
			buildFlags = { "-tags", "integration_tests,draw,integration,unit,slt,export" },
		},
	},
	on_attach = require("charlie.lsp.attach"),
})
