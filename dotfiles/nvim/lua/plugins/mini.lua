return {

	'echasnovski/mini.nvim',

	config = function()
		require('mini.animate').setup({
			cursor = { enable = false },
			scroll = {
				timing = require('mini.animate').gen_timing.linear({
					duration = 85, unit = 'total'
				})
			},
			resize = { enable = false },
			open = { enable = false },
			close = { enable = false },
		})
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
