local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	timeout_ms = 5000,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	debug = false,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						timeout_ms = 5000,
						async = false,
					})
				end,
			})
		end
	end,
	sources = {
		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Go
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,

		-- Rust
		null_ls.builtins.formatting.rustfmt,

		-- JSON
		null_ls.builtins.formatting.jq,

		-- JS
		null_ls.builtins.formatting.prettier,
	},
})
