vim.g["mapleader"] = ","

local telescope = require("telescope.builtin")
local neotest = require("neotest")
local csuggest = require("copilot.suggestion")

require("nest").applyKeymaps({
	{
		"<Leader>",
		{
			{ "F", require("charlie.telescope").project_files },
			{ "G", telescope.live_grep },
			{ "B", telescope.buffers },

			-- Splits
			{ "h", ":<C-u>split<CR>" },
			{ "v", ":<C-u>vsplit<CR>" },

			-- Buffers
			{ "q", ":bp<CR>" },
			{ "w", ":bn<CR>" },

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

					-- Test
					-- TODO: Project specific env vars
					{
						"t",
						{
							-- Test
							{ "t", neotest.run.run },

							-- File
							{
								"f",
								function()
									neotest.run.run(vim.fn.expand("%"))
								end,
							},

							-- Project
							{
								"p",
								function()
									neotest.run.run(vim.fn.getcwd())
								end,
							},

							-- Output
							{ "o", neotest.output.open },
						},
					},
				},
			},

			-- Refactor
			{
				"r",
				{
					{ "r", ":Lspsaga rename<CR>" },
					{ "a", vim.lsp.buf.code_action },
				},
			},

			-- Copilot
			{
				"c",
				{
					"a",
					csuggest.toggle_auto_trigger,
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

	{ "<F2>", ":NvimTreeFindFile<CR>" },
	{ "<F3>", ":NvimTreeToggle<CR>" },

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
	{
		mode = "t",
		{
			{ "<Esc>", [[<C-\><C-n>]] },
		},
	},

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

	{
		mode = "i",
		{
			-- Accept copilot suggestion
			"<C-Space>",
			function()
				csuggest.accept()
			end,
		},
		{
			-- Next copilot suggestion
			"<Tab>",
			function()
				csuggest.next()
			end,
		},
		{
			-- Previous copilot suggestion
			"<S-Tab>",
			function()
				csuggest.prev()
			end,
		},
	},
})
