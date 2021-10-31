local opt = vim.opt

vim.g.color_name = 'dracula'

vim.cmd('colorscheme ' .. vim.g.color_name)
vim.cmd('filetype plugin indent on')
vim.cmd(':verbose setlocal omnifunc?')

local encoding = 'utf-8'
opt.encoding = encoding
opt.fileencoding = encoding
opt.fileencodings = encoding
opt.ttyfast = true

opt.backspace = {'indent', 'eol', 'start'}

opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.expandtab = true

opt.hidden = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.joinspaces = false

opt.fileformats = {'unix', 'dos', 'mac'}

local sh = os.getenv'SHELL'
if sh == nil then
    sh = '/bin/sh'
end
opt.shell = sh

opt.ruler = true
opt.number = true

opt.mousemodel = 'popup'
opt.gfn = 'Monospace 10'

opt.gcr = 'a:blinkon0'
opt.scrolloff = 3

opt.laststatus = 2

opt.modeline = true
opt.modelines = 10

opt.title = true
opt.titleold = "Terminal"
opt.titlestring = '%F'

opt.autoread = true

opt.belloff = 'all'
opt.visualbell = true

opt.wrap = false

if vim.fn.has('unnamedplus') then
    opt.clipboard = {'unnamed', 'unnamedplus'}
end

--Status Line
local function status_line()
    local statusline = {}
    table.insert(statusline, '%F%m%r%h%w%=(%{&ff}/%Y)\\ (line\\ %l\\/%L,\\ col\\ %c)\\')
    if vim.fn.exists('*fugitive#statusline') then
        table.insert(statusline, '%{fugitive#statusline()}')
    end
    return table.concat(statusline)
end
opt.statusline = status_line()

