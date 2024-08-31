return function(client, bufnr)
	if client.supports_method("hierarchicalDocumentSymbolSupport") then
		require("nvim-navic").attach(client, bufnr)
	end

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

	if client.supports_method("textDocument/formatting") then
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					timeout_ms = 1000,
					async = false,
					buffer = bufnr,
				})
			end,
		})
	end
end
