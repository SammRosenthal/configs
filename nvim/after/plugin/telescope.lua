local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local telescope = require("telescope")

vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>?', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>FW', builtin.grep_string, {})

telescope.setup({
	defaults = {
		mappings = {
			i = { ["<C-q>"] = actions.send_to_qflist },
			n = { ["<C-q>"] = actions.send_to_qflist },
		},
	},
})
