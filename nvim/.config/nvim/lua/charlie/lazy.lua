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
        dependencies = "tpope/vim-rhubarb",
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

    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter-context" },
        config = function()
            require("charlie.treesitter")
        end,
        run = ":TSUpdate",
    },
    -- use("nvim-treesitter/playground")

    {
        "windwp/nvim-autopairs",
        dependencies = { "hrsh7th/nvim-cmp" },
        event = "InsertEnter",
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
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("charlie.indent_blankline")
        end,
    },

    -- Util
    { "tpope/vim-commentary" },

    {
        "folke/which-key.nvim",
        config = true,
    },

    -- DAP
    {
        "mfussenegger/nvim-dap",
        event = "BufEnter",
    },
    {
        "leoluz/nvim-dap-go",
        event = "BufEnter",
        config = true,
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "BufEnter",
        config = true,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        event = "BufEnter",
        config = true,
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
    },
    {
        "folke/trouble.nvim",
        event = "BufEnter",
        config = true,
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
        "glepnir/lspsaga.nvim",
        event = "BufRead",
        config = true,
        dependencies = {
            "catppuccin/nvim",
            "nvim-tree/nvim-web-devicons",
        },
        -- opts = {
        --     custom_kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        -- },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufEnter",
    },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "BufEnter",
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
        event = "BufEnter",
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
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    -- Rust
    {
        "simrat39/rust-tools.nvim",
        event = "BufEnter",
        opts = {
            tools = {
                autoSetHints = true,
            },
            server = {
                on_attach = require("charlie.lsp.attach"),
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
                        inlayHints = {
                            locationLinks = false,
                        },
                    },
                },
            },
        },
    },

    -- Go
    {
        "ray-x/go.nvim",
        dependencies = { "ray-x/guihua.lua" },
        event = "BufEnter",
        opts = {
            lsp_codelens = false,
        },
    },
    {
        "sebdah/vim-delve",
        event = "BufEnter",
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

            "nvim-neotest/neotest-go",
            "rouge8/neotest-rust",
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
                    require("neotest-go"),
                    require("neotest-rust"),
                },
            })
        end,
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
    },

    -- Keybindings
    {
        "LionC/nest.nvim",
        lazy = false,
        priority = 1000,
    },
})
