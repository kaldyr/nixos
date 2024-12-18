return {

	'epwalsh/obsidian.nvim',

	event = {
		"BufReadPre " .. vim.fn.expand '~' .. '/Notes/*.md',
		"BufNewFile " .. vim.fn.expand '~' .. '/Notes/*.md',
	},

	opts = {
		completion = { nvim_cmp = true },
		finder = 'telescope.nvim',
		mappings = {
			['gf'] = {
				action = function()
					return require('obsidian').util.gf_passthrough()
				end,
				opts = { buffer = true, expr = true, noremap = false },
			},
			['<cr>'] = {
				action = function()
					return require('obsidian').util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		ui = {
			enable = false,
			checkboxes = {
				[' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
				['x'] = { char = '', hl_group = 'ObsidianDone' },
			},
		},
		workspaces = {
			{ name = 'Notes', path = vim.fn.expand '~' .. '/Notes' },
		},
	},

}
