local null_ls = require("null-ls")

null_ls.setup({
	timeout_ms = 5000,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	debug = true,
	on_attach = function(client)
		if client.server_capabilities.documentFormattingProvider then
			vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 5000 })
                augroup END
            ]])
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

		-- Ruby
		-- null_ls.builtins.formatting.rubocop,
		-- null_ls.builtins.diagnostics.rubocop,
	},
})
