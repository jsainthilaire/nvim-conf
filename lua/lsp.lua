local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

end

local function setup_servers()
  require'lspinstall'.setup()

  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    if server == 'lua' then
      require'lspconfig'[server].setup{
        settings = {
          Lua = {
            completion = {
                keywordSnippet = "Disable",
            },
            diagnostics = {
                globals = {"vim", "use"},
                disable = {"lowercase-global"}
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
          },
        },
        on_attach = on_attach
      }
    elseif server == 'efm' then
      require"lspconfig"[server].setup {
        init_options = {documentFormatting = true},
        filetypes = {"python"},
        settings = {
            rootMarkers = {".git/"},
            languages = {
                python = {
                    {
                        formatCommand = "black --quiet -",
                        formatStdin = true,
                    }
                }
            }
        }
      }
    else
      require'lspconfig'[server].setup{
        on_attach = on_attach
      }
    end
  end

  function format()
    --local utils = require('utils')
   -- utils.opt('o', 'autoread', true)
    vim.lsp.buf.formatting_sync(nil, 500)
  end

  vim.api.nvim_exec([[
    augroup autoFormatGroup
	    autocmd BufWritePre *.go,*.py lua vim.lsp.buf.formatting_sync(nil, 500) 
    augroup END
  ]], true)

end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

