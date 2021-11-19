local lsp_installer_servers = require'nvim-lsp-installer.servers'

local server_available, requested_server = lsp_installer_servers.get_server('sumneko_lua')
if server_available then
    requested_server:on_ready(function() 
        requested_server:setup {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = {'vim'},
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
            capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }
    end)
end
