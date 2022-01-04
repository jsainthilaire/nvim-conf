local lsp_installer = require("nvim-lsp-installer")

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

-- Python virtual env setup
local util = require('lspconfig/util')

local path = util.path

-- TODO: move all python conf to a separate file
local function get_python_path(workspace)
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
    return path.join(venv, 'bin', 'python')
  end

  -- use python system version
  return vim.fn.exepath('python') or 'python'
end

local function get_python_extra_paths(workspace)
   local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
    if match ~= '' then
      local extraPaths = vim.fn.trim(vim.fn.system('poetry env info -p'))
      -- TODO; make python version configurable
      return path.join(extraPaths, 'lib', 'python3.8', 'site-packages')
    end
end



local function setup_servers()
  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = on_attach,
    }

    if server.name == "pyright" then
      opts.settings = {
        python = {
          analysis = {
              typeCheckingMode = "off",
            },
        },
      }

      opts.on_init = function(client)
        local workspace = client.config.root_dir
        local settings = client.config.settings.python
        settings.pythonPath = get_python_path(workspace)
        settings.extraPaths = get_python_extra_paths(workspace)
      end
    end

    if server.name == "sumneko_lua" then
      opts.settings = {
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
      }
    end

    server:setup(opts)
  end)

  function format()
    --local utils = require('utils')
    -- utils.opt('o', 'autoread', true)
    vim.lsp.buf.formatting_sync(nil, 500)
  end

  vim.api.nvim_exec([[
    augroup autoFormatGroup
	    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 500) 
    augroup END
  ]], true)
end

local function _setup_servers_old_deprecated()
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
    elseif server == 'python' then
      require'lspconfig'[server].setup{
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
        on_init = function(client)
          local workspace = client.config.root_dir
          local settings = client.config.settings.python

          settings.pythonPath = get_python_path(workspace)
          settings.extraPaths = get_python_extra_paths(workspace)
        end,
        on_attach = on_attach
      }
    elseif server == 'efm' then
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
	    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 500) 
    augroup END
  ]], true)

end

setup_servers()

