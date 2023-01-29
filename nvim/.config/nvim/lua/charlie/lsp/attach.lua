return function(client, bufnr)
	require("nvim-navic").attach(client, bufnr)

	-- Semantic Highlighting
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

		vim.lsp.buf.semantic_tokens_full()
	end
end
