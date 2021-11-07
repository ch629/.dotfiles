local fn = vim.fn local install_path = fn.stdpath('data') ..
    '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then fn.system({'git', 'clone',
    '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd('packadd packer.nvim')

return require'packer'.startup(function (use)
    use { 'lewis6991/impatient.nvim', run = function() require'impatient' end }

    -- Theme
    use 'Pocco81/Catppuccino.nvim'

    -- Libraries
    use 'nvim-lua/plenary.nvim'

    -- NerdTree
    use 'preservim/nerdtree'

    -- Status line
    use 'nvim-lualine/lualine.nvim'

    -- Keybindings
    use 'LionC/nest.nvim'

    -- Git
    use 'tpope/vim-rhubarb'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'

    -- Telescope
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'nvim-treesitter/playground'

    use 'jiangmiao/auto-pairs'
    use 'dense-analysis/ale'
    use 'Yggdroot/indentLine'

    -- Util
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    -- LSP
    use 'neovim/nvim-lspconfig'
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
    use {'fatih/vim-go', run = ':GoInstallBinaries'}
    use 'sebdah/vim-delve'
end)
