return {

	'nvim-lualine/lualine.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
		'yavorski/lualine-macro-recording.nvim'
	},

	opts = {

		options = {
			show_filename_only = false,
			theme = 'auto',
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' }
		},

		sections = {
			lualine_a = {
				{ 'mode', separator = { left = '', right = '' }, right_padding = 2 },
				{ 'macro_recording', '%s' },
			},
			lualine_b = { 'branch', 'diff' },
			lualine_c = {
				{ 'filename', path = 1 },
			},
			lualine_x = { 'diagnostics' },
			lualine_y = { 'filetype' },
			lualine_z = {
				{ 'location', separator = { left = '', right = '' }, left_padding = 2 },
			}
		},

	},

}
