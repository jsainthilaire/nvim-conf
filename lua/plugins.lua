local M = {}

function M.setup()
  -- Indicates first time installation
  local packer_bootstrap = false

  local conf = {
    profile = {
      enable = true,
      threshold = 1,    
    },

    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end

    local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
    vim.api.nvim_create_autocmd(
      { "BufWritePost" },
      { pattern = "init.lua", command = "source <afile> | PackerCompile", group = packer_grp }
    )
  end

  local function plugins(use)
    use {'wbthomason/packer.nvim'}
    use { "lewis6991/impatient.nvim" }

    use 'tpope/vim-commentary'

    use { "junegunn/fzf" }
    use {
      {
        'nvim-telescope/telescope.nvim',
        requires = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
          'telescope-fzf-native.nvim',
        }
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
      },
      wants = {
        'aerial.nvim'
      }
    }

    use {
      "stevearc/aerial.nvim",
      config = function()
        require("aerial").setup()
      end,
      module = { "aerial" },
      cmd = { "AerialToggle" },
    }

    use {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end
    }

    -- LSP config
    use {
      "neovim/nvim-lspconfig",
      opt = true,
      event = { "BufReadPre" },
      wants = {
        "mason.nvim",
        "mason-lspconfig.nvim",
        "mason-tool-installer.nvim",
        "cmp-nvim-lsp",
        "lua-dev.nvim",
        "vim-illuminate",
        "null-ls.nvim",
        -- "lsp-format.nvim", -- to easily format on save
        "schemastore.nvim",
        "typescript.nvim",
        "goto-preview",
      },
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- { "lvimuser/lsp-inlayhints.nvim", branch = "readme" },
        "folke/lua-dev.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
        --"lukas-reineke/lsp-format.nvim",
        {
          "j-hui/fidget.nvim",
          config = function()
            require("fidget").setup {}
          end,
        },
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/typescript.nvim",
        {
          "rmagatti/goto-preview",
          config = function()
            require("goto-preview").setup {}
          end,
        },
      },
    }

    -- Completion
    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        {
          "L3MON4D3/LuaSnip",
          wants = { "friendly-snippets", "vim-snippets" },
          config = function()
            -- require("config.snip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      },
    }

    use {
      "windwp/nvim-autopairs",
      opt = true,
      event = "InsertEnter",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'marko-cerovac/material.nvim'
    use 'navarasu/onedark.nvim'

    use {
      "nvim-lualine/lualine.nvim",
      after = "nvim-treesitter",
      config = function()
        require("config.lualine").setup()
      end,
      wants = "nvim-web-devicons",
    }

    use {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
      disable = false,
    }

    use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {} end
    }

    -- React ones
    use {'peitalin/vim-jsx-typescript'}
    use {'mlaursen/vim-react-snippets'}
    use {'neoclide/vim-jsx-improve'}
    use {'jose-elias-alvarez/nvim-lsp-ts-utils', after = {'nvim-treesitter'}}

    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }


    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()
  local packer = require "packer"

  -- Performance
  pcall(require, "impatient")
  -- pcall(require, "packer_compiled")

  packer.init(conf)
  packer.startup(plugins)
end

return M

