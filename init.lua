vim.g.mapleader = ' '


local fn = vim.fn

if (not fn.has('gui_running')) and (vim.g['&term'] ~= 'screen' and vim.g['&term'] ~= 'tmux') then
  vim.g['&t_8f'] = "<Esc>[38;2;%lu;%lu;%lum"
  vim.g['&t_8b'] = "<Esc>[48;2;%lu;%lu;%lum"
end


require "utils"
require "options"
require("plugins").setup()
require('keybindings')
require('autocommands')
require('config.theme')
