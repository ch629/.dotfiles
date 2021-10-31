local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

--TODO: How do we auto install these on first run?
require'paq'{
    'savq/paq-nvim';

    {'dracula/vim', as='dracula'};
    'scrooloose/nerdtree';
    'jistr/vim-nerdtree-tabs';
    'tpope/vim-commentary';
    'vim-airline/vim-airline';
    'vim-airline/vim-airline-themes';
    'vim-scripts/CSApprox';
    'Yggdroot/indentLine';
    'fladson/vim-kitty';
    'nvim-lua/plenary.nvim';
    'nvim-treesitter/nvim-treesitter';
    'jiangmiao/auto-pairs';
    'dense-analysis/ale';

    -- Git
    'tpope/vim-rhubarb';
    'tpope/vim-fugitive';
    'airblade/vim-gitgutter';

    -- Telescope
    'nvim-telescope/telescope.nvim';
    'nvim-telescope/telescope-fzy-native.nvim';

    -- LSP
    'neovim/nvim-lspconfig';
    'hrsh7th/cmp-nvim-lsp';
    'hrsh7th/cmp-buffer';
    'hrsh7th/nvim-cmp';
    'hrsh7th/cmp-vsnip';
    'hrsh7th/vim-vsnip';
    'kyazdani42/nvim-web-devicons';
    'folke/trouble.nvim';
    'folke/todo-comments.nvim';
    {'Shougo/vimproc.vim', run='make'};

    -- Go
    'sebdah/vim-delve';
    {'fatih/vim-go', run=':GoInstallBinaries'};
}
