require('telescope').setup {fzf = {fuzzy = true, override_generic_sorter = false, override_file_sorter = true, case_mode = "smart_case" }}
require('telescope').load_extension('fzf')
