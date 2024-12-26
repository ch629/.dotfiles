require("todo-comments").setup({
	signs = true,
	sign_priority = 8,
	keywords = {
		FIX = {
			icon = " ",
			color = "error",
			alt = { "FIXME", "BUG", "FIXIT" },
		},
		TODO = { icon = "✓ ", color = "info" },
		HACK = { icon = " ", color = "warning" },
		WARN = { icon = "⚠ ", color = "warning" },
		NOTE = { icon = " ", color = "hint" },
	},
	merge_keywords = true,
	gui_style = {
		fg = "NONE",
		bg = "BOLD",
	},
	highlight = {
		before = "",
		keyword = "bg",
		after = "fg",
		pattern = [[.*<(KEYWORDS).*\s*:]],
		comments_only = true,
		max_line_len = 400,
		exclude = {},
	},
	colors = {
		error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
		warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
		info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
		hint = { "LspDiagnosticsDefaultHint", "#10B981" },
		default = { "Identifier", "#7C3AED" },
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		pattern = [[\b(KEYWORDS):]],
		-- pattern = [[\b(KEYWORDS)(\(.*\))?\s*:]],
	},
})
