local fn = vim.fn local install_path = fn.stdpath('data') ..
    '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then fn.system({'git', 'clone',
    '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd('packadd packer.nvim')
local use = require'packer'.use

return require'packer'.startup({
    function()
        use {
            'lewis6991/impatient.nvim',
            run = function () require'impatient' end,
        }

        -- Libraries
        use 'nvim-lua/plenary.nvim'

        -- NerdTree
        use {
            'preservim/nerdtree',
            config = function() require'charlie.nerdtree' end,
        }

        -- Status line
        use {
            'nvim-lualine/lualine.nvim',
            config = function() require'charlie.statusline' end,
        }

        -- Git
        use 'tpope/vim-rhubarb'
        use 'tpope/vim-fugitive'
        use 'airblade/vim-gitgutter'

        -- Telescope
        use {
            'nvim-telescope/telescope.nvim',
            config = function() require'charlie.telescope' end,
        }
        use 'nvim-telescope/telescope-fzy-native.nvim'

        use {
            'nvim-treesitter/nvim-treesitter',
            config = function() require'charlie.treesitter' end,
            run = ':TSUpdate',
        }
        use 'nvim-treesitter/playground'

        use 'jiangmiao/auto-pairs'
        use 'dense-analysis/ale'
        use {
            'lukas-reineke/indent-blankline.nvim',
            config = function() require'charlie.indent_blankline' end,
        }

        -- Util
        use 'tpope/vim-commentary'
        use 'tpope/vim-surround'

        use {
            'folke/which-key.nvim',
            config = function() require'which-key'.setup{} end,
        }

        -- LSP
        use {
            'neovim/nvim-lspconfig',
            config = function() require'charlie.lsp' end,
        }
        use 'williamboman/nvim-lsp-installer'
        use 'kyazdani42/nvim-web-devicons'
        use 'folke/trouble.nvim'
        use 'folke/todo-comments.nvim'
        use 'glepnir/lspsaga.nvim'

        -- Completions
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-vsnip'
        use 'hrsh7th/vim-vsnip'

        -- Go
        use {
            'fatih/vim-go',
            run = ':GoInstallBinaries',
        }
        use 'sebdah/vim-delve'

        -- Theme
        use {
            'Pocco81/Catppuccino.nvim',
            config = function()
                require'charlie.catppuccino'
                vim.cmd('colorscheme catppuccino')
            end,
        }

        -- Keybindings
        use {
            'LionC/nest.nvim',
            config = function() require'charlie.bindings' end,
        }
    end,
    config = {
        compile_path = fn.stdpath('config') .. '/lua/packer_compiled.lua',
    },
})
