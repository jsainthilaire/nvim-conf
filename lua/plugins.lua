vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use {'wbthomason/packer.nvim', opt = true}

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
  }

          -- LSP config
  use {'neovim/nvim-lspconfig'}
  use {'kabouzeid/nvim-lspinstall'}
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use {
    'hrsh7th/nvim-compe',
    requires = {
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ'
    }
  }

  use 'marko-cerovac/material.nvim'
end)
