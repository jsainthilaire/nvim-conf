local utils = require('utils')
local silentOpts = {noremap = true, silent = true} 

-- nice window navigation 
utils.map('n', '<C-h>', '<C-w>h')
utils.map('n', '<C-j>', '<C-w>j')
utils.map('n', '<C-k>', '<C-w>k')
utils.map('n', '<C-l>', '<C-w>l')

utils.map('n', '<C-c>', '<Esc>')

-- Telescope
utils.map('n', '<Leader>ff', ':Telescope find_files<CR>', silentOpts)
utils.map('n', '<Leader>fg', ':Telescope live_grep<CR>', silentOpts)
utils.map('n', '<Leader>fb', ':Telescope buffers<CR>', silentOpts)
utils.map('n', '<Leader>fc', ':Telescope find_files cwd=~/.config/nvim<CR>', silentOpts)
utils.map('n', '<Leader>fs', ':Telescope lsp_document_symbols<CR>', silentOpts)
utils.map('n', '<Leader>fd', ':Telescope lsp_document_diagnostics<CR>', silentOpts)
utils.map('n', '<Leader>fD', ':Telescope lsp_workspace_diagnostics<CR>', silentOpts)
