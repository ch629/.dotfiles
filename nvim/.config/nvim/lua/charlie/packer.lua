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

		-- Tree
		use({
			"nvim-tree/nvim-tree.lua",
			requires = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup()
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
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup()
			end,
		})

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
			requires = { "nvim-treesitter/nvim-treesitter-context" },
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

		-- DAP
		use("mfussenegger/nvim-dap")
		use({
			"leoluz/nvim-dap-go",
			config = function()
				require("dap-go").setup()
			end,
		})
		use({
			"rcarriga/nvim-dap-ui",
			config = function()
				require("dapui").setup({})
			end,
		})

		-- LSP
		use({
			"williamboman/mason.nvim",
			requires = {
				"williamboman/mason-lspconfig.nvim",
				"neovim/nvim-lspconfig",
			},
			config = function()
				require("mason").setup()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"gopls",
						"sumneko_lua",
						"rust_analyzer",
						"jsonls",
						"tsserver",
						"yamlls",
						"terraformls",
					},
				})
				require("charlie.lsp")
			end,
		})
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
		use({
			"glepnir/lspsaga.nvim",
			config = function()
				require("lspsaga").init_lsp_saga({
					custom_kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
				})
			end,
		})
		use("jose-elias-alvarez/null-ls.nvim")
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
		use({
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({
					window = {
						blend = 0,
					},
				})
			end,
		})
		use({
			"folke/noice.nvim",
			config = function()
				require("noice").setup({
					messages = {
						view = "mini",
						view_error = "notify",
					},
					notify = {
						view = "mini",
					},
					lsp = {
						progress = {
							enabled = false,
						},
						message = {
							view = "mini",
						},
					},
				})
			end,
			requires = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
		})
		use({
			"SmiteshP/nvim-navic",
			requires = "neovim/nvim-lspconfig",
			config = function()
				require("nvim-navic").setup({
					highlight = true,
				})
				vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
			end,
		})
		use({
			"theHamsta/nvim-semantic-tokens",
			config = function()
				require("nvim-semantic-tokens").setup({
					preset = "default",
					-- highlighters is a list of modules following the interface of nvim-semantic-tokens.table-highlighter or
					-- function with the signature: highlight_token(ctx, token, highlight) where
					--        ctx (as defined in :h lsp-handler)
					--        token  (as defined in :h vim.lsp.semantic_tokens.on_full())
					--        highlight (a helper function that you can call (also multiple times) with the determined highlight group(s) as the only parameter)
					highlighters = { require("nvim-semantic-tokens.table-highlighter") },
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

		-- Rust
		use({
			"simrat39/rust-tools.nvim",
			config = function()
				require("rust-tools").setup({
					tools = {
						autoSetHints = true,
					},
					server = {
						on_attach = function(client, bufnr)
							local caps = client.server_capabilities
							if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
								local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
								vim.api.nvim_create_autocmd("TextChanged", {
									group = augroup,
									buffer = bufnr,
									callback = function()
										vim.lsp.buf.semantic_tokens_full()
									end,
								})
								-- fire it first time on load as well
								vim.lsp.buf.semantic_tokens_full()
							end
							require("nvim-navic").attach(client, bufnr)
						end,
						settings = {
							["rust-analyzer"] = {
								lens = {
									enable = true,
								},
								checkOnSave = {
									command = "clippy",
								},

								imports = {
									granularity = {
										group = "module",
									},
									prefix = "self",
								},
								cargo = {
									buildScripts = {
										enable = true,
									},
								},
								procMacro = {
									enable = true,
								},
							},
						},
					},
				})
			end,
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

				"nvim-neotest/neotest-go",
				"rouge8/neotest-rust",
			},
			config = function()
				-- get neotest namespace (api call creates or returns namespace)
				local neotest_ns = vim.api.nvim_create_namespace("neotest")
				vim.diagnostic.config({
					virtual_text = {
						format = function(diagnostic)
							local message = diagnostic.message
								:gsub("\n", " ")
								:gsub("\t", " ")
								:gsub("%s+", " ")
								:gsub("^%s+", "")
							return message
						end,
					},
				}, neotest_ns)
				require("neotest").setup({
					adapters = {
						require("neotest-go"),
						require("neotest-rust"),
					},
				})
			end,
		})

		-- Theme
		use({
			"catppuccin/nvim",
			as = "catppuccin",
			config = function()
				require("catppuccin").setup({
					flavour = "mocha", -- latte, frappe, macchiato, mocha
					background = { -- :h background
						light = "latte",
						dark = "mocha",
					},
					transparent_background = false,
					term_colors = true,
					dim_inactive = {
						enabled = false,
						shade = "dark",
						percentage = 0.15,
					},
					no_italic = false, -- Force no italic
					no_bold = false, -- Force no bold
					styles = {
						comments = { "italic" },
						conditionals = { "italic" },
						loops = {},
						functions = {},
						keywords = {},
						strings = {},
						variables = {},
						numbers = {},
						booleans = {},
						properties = {},
						types = {},
						operators = {},
					},
					color_overrides = {},
					custom_highlights = {},
					integrations = {
						cmp = true,
						gitsigns = true,
						nvimtree = true,
						telescope = true,
						notify = true,
						mason = true,
						neotest = true,
						which_key = true,
						lsp_trouble = true,
						treesitter = true,
						navic = { enabled = true, custom_bg = "NONE" },
						fidget = true,
						indent_blankline = {
							enabled = true,
							colored_indent_levels = false,
						},
						treesitter_context = true,
						noice = true,
						semantic_tokens = true,
						lsp_saga = true,
						-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
					},
				})
				vim.cmd([[colorscheme catppuccin]])
			end,
		})

		-- Keybindings
		use("LionC/nest.nvim")
	end,
	config = {
		compile_path = fn.stdpath("config") .. "/lua/packer_compiled.lua",
	},
})
