require("telescope").load_extension("fzy_native")
require("telescope").load_extension("noice")

require("telescope").setup({
	defaults = {
		file_ignore_patterns = { "vendor" },
	},
	pickers = {
		buffers = {
			show_all_buffers = true,
			sort_lastused = true,
			theme = "dropdown",
			previewer = false,
			mappings = {
				i = {
					["<c-d>"] = "delete_buffer",
				},
			},
		},
		lsp_code_actions = {
			theme = "dropdown",
			previewer = false,
		},
	},
})

local M = {}

function M.project_files()
	local ok = pcall(require("telescope.builtin").git_files)
	if not ok then
		require("telescope.builtin").find_files()
	end
end

return M
