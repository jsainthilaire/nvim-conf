vim.g.mapleader = ' '

require('options')

-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

if (not fn.has('gui_running')) and (vim.g['&term'] ~= 'screen' and vim.g['&term'] ~= 'tmux') then
  vim.g['&t_8f'] = "<Esc>[38;2;%lu;%lu;%lum"
  vim.g['&t_8b'] = "<Esc>[48;2;%lu;%lu;%lum"
end


require('plugins')

require('lsp')

require('keybindings')

require('autocommands')

require('config.completion')
require('config.theme')
