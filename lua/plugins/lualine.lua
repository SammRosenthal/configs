return { 
	"nvim-lualine/lualine.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	opts = {
		options = {
			icons_enabled = false,
			component_separators = '|',
			section_separators = '',
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch', },
			lualine_c = { 'filename' },
			lualine_x = {},
			lualine_y = { 'diff', 'diagnostics' },
			lualine_z = { 'location' }
		},
	
	} 
}
