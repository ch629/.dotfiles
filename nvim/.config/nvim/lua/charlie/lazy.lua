local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        init = function()
            vim.api.nvim_create_autocmd({ "VimEnter" }, {
                callback = function(data)
                    -- buffer is a directory
                    local directory = vim.fn.isdirectory(data.file) == 1

                    if not directory then
                        return
                    end

                    -- change to the directory
                    vim.cmd.cd(data.file)

                    -- open the tree
                    require("nvim-tree.api").tree.open()
                end,
            })
        end,
        config = true,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("charlie.statusline")
        end,
    },

    -- Git
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
            "tpope/vim-commentary",
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufEnter",
        config = true,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" },
        config = function()
            require("charlie.telescope")
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter-context" },
        config = function()
            require("charlie.treesitter")
        end,
        run = ":TSUpdate",
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "UIEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "UIEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        opts = {
            keymaps = {
                useDefaults = true,
            },
        },
    },
    {
        "hiphish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "BufEnter",
    },

    {
        "windwp/nvim-autopairs",
        dependencies = { "hrsh7th/nvim-cmp" },
        event = "InsertEnter",
        config = function()
            local npairs = require("nvim-autopairs")

            npairs.setup({
                check_ts = true,
                ts_config = {
                    lua = { "string" }, -- it will not add a pair on that treesitter node
                    go = { "interpreted_string_literal", "raw_string_literal" },
                },
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- LSP
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "gopls",
                    "lua_ls",
                    "rust_analyzer",
                    "jsonls",
                    "ts_ls",
                    "yamlls",
                    "terraformls",
                },
            })
            require("charlie.lsp")
        end,
    },
    {
        "folke/trouble.nvim",
        event = "BufEnter",
        config = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "folke/todo-comments.nvim",
        event = "BufEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
                lightbulb = {
                    enable = false,
                },
            })
        end,
        dependencies = {
            "catppuccin/nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "nvimtools/none-ls.nvim",
        event = "BufEnter",
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        init = function()
            -- Disable default diagnostics
            vim.diagnostic.config({
                virtual_text = false,
            })
        end,
        config = true,
    },
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy",
        opts = {
            window = {
                blend = 0,
            },
        },
    },
    {
        "folke/noice.nvim",
        opts = {
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
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    {
        "SmiteshP/nvim-navic",
        event = "BufEnter",
        dependencies = "neovim/nvim-lspconfig",
        init = function()
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end,
        opts = {
            highlight = true,
        },
    },
    {
        "theHamsta/nvim-semantic-tokens",
        event = "BufEnter",
        opts = {
            preset = "default",
        },
    },

    -- Completions
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        event = "InsertEnter",
        dependencies = {
            "giuxtaposition/blink-cmp-copilot",
        },

        -- use a release tag to download pre-built binaries
        version = "*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = "enter",
                cmdline = {
                    preset = "super-tab",
                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {
                    "copilot",
                    "lsp",
                    "buffer",
                    "path",
                },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },

    -- Rust
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    autoSetHints = true,
                },
                server = {
                    on_attach = require("charlie.lsp.attach"),
                    default_settings = {
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
                            inlayHints = {
                                locationLinks = false,
                            },
                        },
                    },
                },
            }
        end,
    },

    -- Go
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        event = "CmdlineEnter",
        ft = { "go", "gomod" },
        opts = {
            lsp_codelens = false,
        },
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                enabled = true,
            },
            select = {
                enabled = true,
                backend = { "telescope", "builtin" },
            },
        },
    },

    {
        "stevearc/overseer.nvim",
        config = true,
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/nvim-nio",

            "fredrikaverpil/neotest-golang",
        },
        event = "BufEnter",
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
                    require("neotest-golang")({
                        go_test_args = {
                            "-race",
                            "-count=1",
                            "-tags=integration_tests",
                        },
                    }),
                    require("rustaceanvim.neotest"),
                },
            })
        end,
        opts = {
            -- See all config options with :h neotest.Config
            discovery = {
                -- Drastically improve performance in ginormous projects by
                -- only AST-parsing the currently opened buffer.
                enabled = false,
                -- Number of workers to parse files concurrently.
                -- A value of 0 automatically assigns number based on CPU.
                -- Set to 1 if experiencing lag.
                concurrent = 1,
            },
            running = {
                -- Run tests concurrently when an adapter provides multiple commands to run.
                concurrent = true,
            },
            summary = {
                -- Enable/disable animation of icons.
                animated = false,
            },
        },
    },

    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = {
                    -- :h background
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
    },

    {
        "zbirenbaum/copilot.lua",
        event = "BufEnter",
        config = true,
    },

    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        config = true,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
    },

    -- Keybindings
    {
        "LionC/nest.nvim",
        lazy = false,
        priority = 1000,
    },
})
