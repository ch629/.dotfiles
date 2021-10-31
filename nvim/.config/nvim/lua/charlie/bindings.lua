vim.g['mapleader'] = ','

-- TODO: Find a way to load in language specific bindings using ftplugin
--  -> Possibly assign some vars that this can access?
require'nest'.applyKeymaps {
    { '<leader>', {
        { mode = 'n', {
            { 'F', require'charlie.telescope'.project_files },
            { 'G', require'telescope.builtin'.live_grep },
            { 'B', require'telescope.builtin'.buffers },
        }},

        -- Go
        { 'd', {
            -- https://github.com/fatih/vim-go/blob/master/ftplugin/go/mappings.vim
            { 'd', ':<C-u>call go#def#Jump("vsplit", 0)<CR>' }, -- go-def-vertical
            { 'v', ':<C-u>call go#doc#Open("vnew", "vsplit")<CR>' }, -- go-doc-vertical
            { 'b', ':<C-u>call go#doc#OpenBrowser()<CR>' }, -- go-doc-browser
        }},

        { 'sh', ':terminal<CR>' },

        -- Splits
        { 'h', ':<C-u>split<CR>' },
        { 'v', ':<C-u>vsplit<CR>' },

        -- Buffers
        { 'z', ':bp<CR>' },
        { 'w', ':bn<CR>' },
        { 'c', ':bd<CR>' },

        { '<space>', ':noh<CR>' },

        -- Git
        { 'gc', ':Git commit --verbose<CR>' },
        { 'gsh', ':Git push<CR>' },
        { 'gll', ':Git pull<CR>' },
        { 'gs', ':Git<CR>' },
        { 'gb', ':Git blame<CR>' },
        { 'gd', ':Git diff<CR>' },
    }},

    { mode = 'n', {
        { '<F2>', ':NERDTreeFind<CR>' },
        { '<F3>', ':NERDTreeToggle<CR>' },
    }},
}
