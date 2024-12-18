return {

	'echasnovski/mini.nvim',

	config = function()
		require('mini.basics').setup({
			options = {
				basic = true,
				extra_ui = true,
				win_borders = 'bold'
			},
			mappings = {
				basic = true,
				option_toggle_prefix = [[\]],
				windows = true,
			},
			autocommands = {
				basic = true,
				relnum_in_visual_mode = true,
			},
			silent = true,
		})
		require('mini.bracketed').setup()
		require('mini.bufremove').setup()
		require('mini.cursorword').setup()
		require('mini.hipatterns').setup({
			highlighters = {
				hex_color = require('mini.hipatterns').gen_highlighter.hex_color()
			}
		})
		require('mini.icons').setup()
		require('mini.indentscope').setup({ symbol = "▏" })
		require('mini.operators').setup()
		require('mini.pairs').setup()
		require('mini.splitjoin').setup({
			mappings = {
				toggle = 'gj',
			},
		})
		require('mini.surround').setup()
	end,

}
