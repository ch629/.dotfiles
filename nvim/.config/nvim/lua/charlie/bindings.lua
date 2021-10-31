vim.g['mapleader'] = ','

local function build_go_files()
    local bufName = vim.api.nvim_buf_get_name(0)
    if bufName:match('.+_test\\.go$') then
        vim.cmd('call go#test#Test(0, 1)')
    else
        vim.cmd('call go#cmd#Build(0)')
    end
end

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
        { 'rb', build_go_files },
        { mode = 'n', {
            { 'r', ':<C-u>call go#cmd#Run(!g:go_jump_to_error)<CR>' }, -- go-run
            { 't', ':<C-u>call go#test#Test(!g:go_jump_to_error, 0)<CR>' }, -- go-test
            { 'gt', ':<C-u>call go#coverage#BufferToggle(!g:go_jump_to_error)<CR>' }, -- go-coverage-toggle
            { 'i', ':<C-u>call go#tool#Info(1)<CR>' }, -- go-info
            { 'l', ':<C-u>call go#lint#Gometa(!g:go_jump_to_error, 0)<CR>', options={silent=true}}, --go-metalinter
        }},

        { 'sh', ':terminal<CR>' },

        -- Splits
        { 'h', ':<C-u>split<CR>' },
        { 'v', ':<C-u>vsplit<CR>' },

        -- Buffers
        { 'q', ':bp<CR>' },
        { 'w', ':bn<CR>' },
        { 'c', ':bd<CR>' },

        { '<space>', ':noh<CR>' },

        -- Git
        { 'g', {
            { 'c',  ':Git commit --verbose<CR>' },
            { 'sh', ':Git push<CR>' },
            { 'll', ':Git pull<CR>' },
            { 's',  ':Git<CR>' },
            { 'b',  ':Git blame<CR>' },
            { 'd',  ':Git diff<CR>' },
        }},

    }},

    -- Window Switching
    { '<C-', {
        { 'j>', '<C-w>j' },
        { 'k>', '<C-w>k' },
        { 'l>', '<C-w>l' },
        { 'h>', '<C-w>h' },
    }},

    { mode = 'n', {
        { '<F2>', ':NERDTreeFind<CR>' },
        { '<F3>', ':NERDTreeToggle<CR>' },

        -- Resize splits
        { '<S-', {
            { 'Up>',    ":res +5<CR>" },
            { 'Down>',  ":res -5<CR>" },
            { 'Left>',  ":vertical resize -5<CR>" },
            { 'Right>', ":vertical resize +5<CR>" },
        }},

        { 'n', 'nzzzv' },
        { 'N', 'Nzzzv' },
    }},

    -- Terminal
    { mode = 't', {
        { '<Esc>', '<-\\><C-n>' },
    }},


    -- Move visual block
    { mode = 'v', {
        { 'J', ':m \'>+1<CR>gv=gv' },
        { 'K', ':m \'<-2<CR>gv=gv' },

        { '<', '<gv', options={noremap=false}},
        { '>', '>gv', options={noremap=false}},
    }},
}
