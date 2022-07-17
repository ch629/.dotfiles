vim.g["mapleader"] = ","

local telescope = require("telescope.builtin")

require("nest").applyKeymaps({
	{
		"<Leader>",
		{
			{ "F", require("charlie.telescope").project_files },
			{ "G", telescope.live_grep },
			{ "B", telescope.buffers },

			-- Open terminal
			{ "sh", ":terminal<CR>" },

			-- Splits
			{ "h", ":<C-u>split<CR>" },
			{ "v", ":<C-u>vsplit<CR>" },

			-- Buffers
			{ "q", ":bp<CR>" },
			{ "w", ":bn<CR>" },
			{ "c", ":bd<CR>" },

			{ "<Space>", ":noh<CR>" },

			{
				"g",
				{
					-- Git
					{ "c", ":Git commit --verbose<CR>" },
					{ "sh", ":Git push<CR>" },
					{ "ll", ":Git pull<CR>" },
					{ "s", ":Git<CR>" },
					{ "b", ":Git blame<CR>" },

					-- Goto
					{ "d", telescope.lsp_definitions }, -- definition
					{ "i", telescope.lsp_implementations }, -- implementation
					{ "r", telescope.lsp_references }, -- references
				},
			},

			-- Refactor
			{
				"r",
				{
					{ "r", require("lspsaga.rename").lsp_rename },
				},
			},
		},
	},

	-- Window Switching
	{
		"<C-",
		{
			{ "j>", "<C-w>j" },
			{ "k>", "<C-w>k" },
			{ "l>", "<C-w>l" },
			{ "h>", "<C-w>h" },
		},
	},

	{ "<F2>", ":NERDTreeFind<CR>" },
	{ "<F3>", ":NERDTreeToggle<CR>" },

	-- Resize splits
	{
		"<S-",
		{
			{ "Up>", ":resize +5<CR>" },
			{ "Down>", ":resize -5<CR>" },
			{ "Left>", ":vertical resize -5<CR>" },
			{ "Right>", ":vertical resize +5<CR>" },
		},
	},

	-- Searching
	{ "n", "nzzzv" },
	{ "N", "Nzzzv" },

	-- Terminal
	{ mode = "t", {
		{ "<Esc>", [[<C-\><C-n>]] },
	} },

	-- Move visual block
	{
		mode = "v",
		{
			{ "J", [[:m '>+1<CR>gv=gv]] },
			{ "K", [[:m '<-2<CR>gv=gv]] },

			-- Keep visual block on indent
			{ "<", "<gv", options = { noremap = false } },
			{ ">", ">gv", options = { noremap = false } },
		},
	},

	{ mode = "i", {
		"<C-u>",
		require("luasnip.extras.select_choice"),
	} },
})
