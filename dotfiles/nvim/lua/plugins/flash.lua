return {

	'folke/flash.nvim',

	event = 'VeryLazy',

	keys = {
		{ '<C-f>', function() require('flash').jump() end, mode = { 'n', 'x', 'o' }, desc = 'Flash' }
	},

	opts = {},

}
