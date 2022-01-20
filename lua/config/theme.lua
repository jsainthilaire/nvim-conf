local utils = require('utils')

utils.opt('o', 'termguicolors', true)

-- Material config
--vim.g.material_style = 'deep ocean'
vim.cmd 'colorscheme onedark'

--vim.cmd [[au VimEnter * highlight NonText guifg=#4a4a59]]
--vim.cmd [[au VimEnter * highlight SpecialKey guifg=#4a4a5]]

vim.g.onedark_style = 'dark'
vim.g.onedark_transparent_background = true
require('onedark').setup()

