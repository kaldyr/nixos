return {

	'folke/snacks.nvim',

	priority = 1000,
	lazy = false,

	init = function()
		vim.api.nvim_create_autocmd( 'User', {
			pattern = 'VeryLazy',
			callback = function()
				local t = require('snacks.toggle')
				t.diagnostics():map('\\d')
				t.inlay_hints():map('\\h')
				t.line_number({ name = 'Line Number' }):map('\\n')
				t.option('background', { on = 'dark', off = 'light', name = 'Dark Mode' }):map('\\b')
				t.option('cursorcolumn', {name = 'Highlight Cursor Column'}):map('\\C')
				t.option('cursorline', {name = 'Highlight Cursor Line'}):map('\\c')
				t.option('list', {name = 'List Characters'}):map('\\l')
				t.option('relativenumber', { name = 'Relative Number' }):map('\\r')
				t.option('spell', { name = 'Spelling' }):map('\\s')
				t.option('wrap', {name = 'Wrap'}):map('\\w')
			end
		} )
	end,

	opts = {

		bigfile = { enabled = true },

		indent = {
			enabled = true,
			indent = {
				char = "🢒", -- Set if using chunk
				-- char = "│", -- Set if not using chunk
			},
			scope = {
				char = "│",
			},
			chunk = {
				enabled = true,
				char = {
					corner_top = "╭",
					corner_bottom = "╰",
				},
				hl = { 'SnacksIndentChunk' },
				only_current = true,
			},
		},

		notifier = { enabled = true },
		scope = { enabled = true },

		scroll = {
			enabled = true,
			animate = {
				duration = { step = 15, total = 150 },
			},
		},

		statuscolumn = {
			enable = true,
			folds = { open = true },
		},

		toggle = {
			enabled = true,
			color = {
				enabled = "green",
				disabled = "red",
			},
			notify = true,
			which_key = true,
		},

	},

}
