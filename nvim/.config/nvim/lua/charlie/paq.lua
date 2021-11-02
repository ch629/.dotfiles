local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

-- Auto install packages on VimEnter
vim.cmd('autocmd VimEnter * PaqInstall')

require'paq'{
    'savq/paq-nvim';

    -- Theme
    'Pocco81/Catppuccino.nvim';

    -- Libraries
    'nvim-lua/plenary.nvim';
    {'Shougo/vimproc.vim', run='make'};

    -- NerdTree
    'scrooloose/nerdtree';
    'jistr/vim-nerdtree-tabs';

    -- Status line
    'nvim-lualine/lualine.nvim';

    -- Keybindings
    'LionC/nest.nvim';

    -- Git
    'tpope/vim-rhubarb';
    'tpope/vim-fugitive';
    'airblade/vim-gitgutter';

    -- Telescope
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-fzy-native.nvim';

    'nvim-treesitter/nvim-treesitter';
    'jiangmiao/auto-pairs';
    'dense-analysis/ale';
    'Yggdroot/indentLine';

    -- Util
    'tpope/vim-commentary';
    'tpope/vim-surround';

    -- LSP
    'neovim/nvim-lspconfig';
    'kyazdani42/nvim-web-devicons';
    'folke/trouble.nvim';
    'folke/todo-comments.nvim';

    -- Completions
    'hrsh7th/cmp-nvim-lsp';
    'hrsh7th/cmp-buffer';
    'hrsh7th/nvim-cmp';
    'hrsh7th/cmp-vsnip';
    'hrsh7th/vim-vsnip';

    -- Go
    {'fatih/vim-go', run=':GoInstallBinaries'};
    'sebdah/vim-delve';
}
