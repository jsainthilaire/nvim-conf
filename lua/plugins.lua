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

  local function lazy_init()
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
      vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
      })
    end
    vim.opt.rtp:prepend(lazypath)
  end

  local function plugins()
    return {
    {'wbthomason/packer.nvim'},
    { "lewis6991/impatient.nvim" },

    'tpope/vim-commentary',

    { "junegunn/fzf" },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
          'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim',
          'telescope-fzf-native.nvim',
          'aerial.nvim'
        },
        config = function() 
          require('telescope').setup {
            fzf = {fuzzy = true, override_generic_sorter = false, override_file_sorter = true, case_mode = "smart_case" }
          }
          require('telescope').load_extension('fzf')
        end,
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
      wants = {
      }
    },

    {
      "stevearc/aerial.nvim",
      config = function()
        require("aerial").setup()
      end,
      module = { "aerial" },
      cmd = { "AerialToggle" },
    },

    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end
    },

    -- LSP config
    {
      "neovim/nvim-lspconfig",
      opt = true,
      event = { "BufReadPre" },
      wants = {

      },
      config = function()
        require("config.lsp").setup()
      end,
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/nvim-cmp",
  --      "folke/neodev.nvim",
        -- "lsp-format.nvim", -- to easily format on save
        "schemastore.nvim",
        "typescript.nvim",
        -- { "lvimuser/lsp-inlayhints.nvim", branch = "readme" },
        "RRethy/vim-illuminate",
        {"jose-elias-alvarez/null-ls.nvim", dependencies = {'nvim-lua/plenary.nvim'}},
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
    },

    -- Completion
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      dependencies = {
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
          -- follow latest release.
          version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
          -- install jsregexp (optional!).
          build = "make install_jsregexp"
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      },
    },

    {
      "windwp/nvim-autopairs",
      opt = true,
      event = "InsertEnter",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    },

    { 
      'nvim-treesitter/nvim-treesitter', 
      build = ':TSUpdate',
      dependencies = {
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        {
          "nvim-lualine/lualine.nvim", 
          dependencies = "nvim-web-devicons", 
          config = function()
            require("config.lualine").setup()
          end,
        },
      }
    },
    'marko-cerovac/material.nvim',
    'navarasu/onedark.nvim',

    {
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
      disable = false,
    },

    {
      'kyazdani42/nvim-tree.lua',
      dependencies = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {} end
    },

    -- React ones
    {'peitalin/vim-jsx-typescript'},
    {'mlaursen/vim-react-snippets'},
    {'neoclide/vim-jsx-improve'},

    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    },
  }
  end

  lazy_init()
  require("lazy").setup(plugins())

  -- Performance
  pcall(require, "impatient")
  -- pcall(require, "packer_compiled")
end

return M

