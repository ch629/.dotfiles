vim.g["mapleader"] = ","

local function build_go_files()
	local bufName = vim.api.nvim_buf_get_name(0)
	if bufName:match(".+_test\\.go$") then
		vim.cmd("call go#test#Test(0, 1)")
	else
		vim.cmd("call go#cmd#Build(0)")
	end
end

local telescope = require("telescope.builtin")

-- TODO: Find a way to load in language specific bindings using ftplugin
--  -> Possibly assign some vars that this can access?
require("nest").applyKeymaps({
	{
		"<Leader>",
		{
			{ "F", require("charlie.telescope").project_files },
			{ "G", telescope.live_grep },
			{ "B", telescope.buffers },

			-- Go
			{
				"d",
				{
					-- https://github.com/fatih/vim-go/blob/master/ftplugin/go/mappings.vim
					{ "d", ':<C-u>call go#def#Jump("vsplit", 0)<CR>' }, -- go-def-vertical
					{ "v", ':<C-u>call go#doc#Open("vnew", "vsplit")<CR>' }, -- go-doc-vertical
					{ "b", ":<C-u>call go#doc#OpenBrowser()<CR>" }, -- go-doc-browser
				},
			},
			{ "rb", build_go_files },
			-- { "r", ":<C-u>call go#cmd#Run(!g:go_jump_to_error)<CR>" }, -- go-run
			{ "t", ":<C-u>call go#test#Test(!g:go_jump_to_error, 0)<CR>" }, -- go-test
			{ "gt", ":<C-u>call go#coverage#BufferToggle(!g:go_jump_to_error)<CR>" }, -- go-coverage-toggle
			{ "i", ":<C-u>call go#tool#Info(1)<CR>" }, -- go-info
			{ "l", ":<C-u>call go#lint#Gometa(!g:go_jump_to_error, 0)<CR>", options = { silent = true } }, --go-metalinter

			-- Tests
			{
				"t",
				{
					{ "t", ":GoTestFunc!<CR>" }, -- run test
					{ "c", ":GoCoverageToggle!<CR>" }, -- toggle cov
				},
			},

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
					-- { "d", ":Git diff<CR>" },

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
					-- TODO: Write my own? - Would prefer it to fill the current name but in a floating window
					--   vim.fn.expand("<cword>") for current name without TS
					{ "r", require("lspsaga.rename").rename },
					-- TODO: Update means this breaks bindings?
					-- { "a", telescope.lsp_code_actions }, -- actions
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
		"<c-u>",
		require("luasnip.extras.select_choice"),
	} },
})
