local navic = require("nvim-navic")
require("lspconfig").gopls.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				fieldalignment = true,
			},
			staticcheck = true,
			codelenses = {
				generate = true,
				gc_details = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		local caps = client.server_capabilities
		if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
			local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
			vim.api.nvim_create_autocmd("TextChanged", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.semantic_tokens_full()
				end,
			})
			-- fire it first time on load as well
			vim.lsp.buf.semantic_tokens_full()
		end
		navic.attach(client, bufnr)
	end,
})
