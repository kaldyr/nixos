return {

	'mikavilpas/yazi.nvim',
	event = 'VeryLazy',

	keys = {
		{ '<leader>y', '<Cmd>Yazi cwd<CR>', desc = 'Yazi File Manager' }
	},

	opts = {
		floating_window_scaling_factor = 0.8
	},

}
