return {

	'romgrk/barbar.nvim',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},

	lazy = false,

	keys = {
		{ '<C-p>', ':BufferPick<CR>', noremap = true, silent = true },
		{ '<C-n>', ':BufferPin<CR>', noremap = true, silent = true },
		-- Keyd used to remap the following to get around the C-, C-. limitations of neovim
		{ '<Leader>bp', ':BufferPrevious<CR>', noremap = true, silent = true }, -- <C-,>
		{ '<Leader>bn', ':BufferNext<CR>', noremap = true, silent = true }, -- <C-.>
		{ '<Leader>BP', ':BufferMovePrevious<CR>', noremap = true, silent = true }, -- <C-S-,>
		{ '<Leader>BN', ':BufferMoveNext<CR>', noremap = true, silent = true }, -- <C-S-.>
	},

	opts = {
		auto_hide = 1
	},

}
