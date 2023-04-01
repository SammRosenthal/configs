require("no-neck-pain").setup({
	width = 100,
	autocmds = {
		enableOnVimEnter = true,
	},
	buffers = {
		setNames = true,
		scratchPad = {
			enabled = true,
			fileName = "notes",
		},
	},
})
