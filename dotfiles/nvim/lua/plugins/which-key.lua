return {

	'folke/which-key.nvim',

	event = 'VeryLazy',

	keys = {
		{
			'<leader>?',
			function()
				require('which-key').show({ global = false })
			end,
			desc = 'Buffer Local Keymaps (which-key)',
		},
	},

	opts = {
		preset = 'helix',
	},

	config = function(_, opts)
		local wk = require('which-key')
		wk.setup(opts)
		wk.add({
			{ '\\', group = 'Toggle' },
			{ ' ', group = 'Pickers' },
		})
	end,

}
