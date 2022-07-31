local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path })
end

vim.cmd("packadd packer.nvim")
local use = require("packer").use

return require("packer").startup({
	function()
		use({
			"lewis6991/impatient.nvim",
			run = function()
				require("impatient")
			end,
		})

		-- NerdTree
		use({
			"preservim/nerdtree",
			config = function()
				require("charlie.nerdtree")
			end,
		})

		-- Status line
		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("charlie.statusline")
			end,
		})

		-- Git
		use({
			"tpope/vim-fugitive",
			requires = "tpope/vim-rhubarb",
		})
		use("airblade/vim-gitgutter")

		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
			config = function()
				require("charlie.telescope")
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("charlie.treesitter")
			end,
			run = ":TSUpdate",
		})
		-- use("nvim-treesitter/playground")

		use({
			"windwp/nvim-autopairs",
			requires = { "hrsh7th/nvim-cmp" },
			config = function()
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				local cmp = require("cmp")
				local npairs = require("nvim-autopairs")

				npairs.setup({
					check_ts = true,
					ts_config = {
						lua = { "string" }, -- it will not add a pair on that treesitter node
						go = { "interpreted_string_literal", "raw_string_literal" },
					},
				})
				cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
			end,
		})
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("charlie.indent_blankline")
			end,
		})

		-- Util
		use("tpope/vim-commentary")

		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({})
			end,
		})

		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = function()
				require("charlie.lsp")
			end,
		})
		use("williamboman/nvim-lsp-installer")
		use({
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup({})
			end,
		})
		use({
			"folke/todo-comments.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		})
		use("glepnir/lspsaga.nvim")
		use("jose-elias-alvarez/null-ls.nvim")
		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup()
			end,
		})
		use({
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			config = function()
				require("lsp_lines").setup()
				-- Disable default diagnostics
				vim.diagnostic.config({
					virtual_text = false,
				})
			end,
		})

		-- Completions
		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
		})

		-- Go
		use({
			"ray-x/go.nvim",
			requires = { "ray-x/guihua.lua" },
			config = function()
				require("go").setup({
					lsp_codelens = false,
				})
			end,
		})
		use("sebdah/vim-delve")
		use({
			"stevearc/dressing.nvim",
			config = function()
				require("dressing").setup({
					input = {
						enabled = true,
					},
					select = {
						enabled = true,
						backend = { "telescope", "builtin" },
					},
				})
			end,
		})

		use({
			"stevearc/overseer.nvim",
			config = function()
				require("overseer").setup()
			end,
		})

		use({
			"nvim-neotest/neotest",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"antoinemadec/FixCursorHold.nvim",
				"stevearc/overseer.nvim",
				"nvim-neotest/neotest-go",
			},
			config = function()
				require("neotest").setup({
					adapters = {
						require("neotest-go"),
					},
				})
			end,
		})

		-- Theme
		use({
			"folke/tokyonight.nvim",
			config = function()
				vim.g.tokyonight_style = "night"
				vim.cmd([[colorscheme tokyonight]])
			end,
		})

		-- Keybindings
		use({
			"LionC/nest.nvim",
			config = function()
				require("charlie.bindings")
			end,
		})
	end,
	config = {
		compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua",
	},
})
