require("lspconfig").rust_analyzer.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_attach = require("charlie.lsp.attach"),
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})
