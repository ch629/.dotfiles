local null_ls = require("null-ls")

null_ls.setup({
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	debug = true,
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
                augroup END
            ]])
		end
	end,
	sources = {
		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Go
		null_ls.builtins.diagnostics.golangci_lint,
		null_ls.builtins.formatting.gofumpt,

		-- Rust
		null_ls.builtins.formatting.rustfmt,
	},
})
