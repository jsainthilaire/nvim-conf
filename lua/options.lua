local utils = require('utils')
local cmd = vim.cmd
local indent = 2

cmd 'syntax enable'
cmd 'filetype plugin indent on'

utils.opt('b', 'autoindent', true)
utils.opt('b', 'expandtab', true)
utils.opt('b', 'shiftwidth', indent)
utils.opt('b', 'smartindent', true)
utils.opt('b', 'tabstop', indent)
utils.opt('o', 'shiftround', true)

utils.opt('o', 'undofile', true)
utils.opt('o', 'undodir', vim.fn.expand('$HOME/.config/nvim/.undo'))
utils.opt('o', 'undolevels', 10000)

utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)
utils.opt('w', 'signcolumn', 'yes')

utils.opt('o', 'clipboard','unnamed,unnamedplus')
utils.opt('o', 'mouse','a')

utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)

utils.opt('o', 'updatetime', 300)
utils.opt('o', 'timeoutlen', 500)

