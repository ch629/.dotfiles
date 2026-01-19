vim.lsp.config("clangd", {
	capabilities = require("charlie.lsp.capabilities"),
	on_attach = require("charlie.lsp.attach"),
	filetypes = { "h", "hpp", "c", "cpp", "cuh", "cu", "objc", "objcpp" },
})
