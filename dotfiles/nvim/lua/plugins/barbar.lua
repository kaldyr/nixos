return {

	'romgrk/barbar.nvim',

	dependencies = {
		'lewis6991/gitsigns.nvim',
		'nvim-tree/nvim-web-devicons',
	},

	lazy = false,

	keys = {
		{ '<C-p>', ':BufferPick<CR>', noremap = true, silent = true, desc = 'Pick Buffer' },
		{ '<C-n>', ':BufferPin<CR>', noremap = true, silent = true, desc = 'Pin Buffer' },
		-- Keyd used to remap the following to get around the C-, C-. limitations of neovim
		{ '[b', ':BufferPrevious<CR>', noremap = true, silent = true, desc = 'Previous Buffer' }, -- <C-,>
		{ ']b', ':BufferNext<CR>', noremap = true, silent = true, desc = 'Next Buffer' }, -- <C-.>
		{ '{B', ':BufferMovePrevious<CR>', noremap = true, silent = true, desc = 'Move Buffer Left' }, -- <C-S-,>
		{ '}B', ':BufferMoveNext<CR>', noremap = true, silent = true, desc = 'Move Buffer Right' }, -- <C-S-.>
		{ '[t', ':tabprev<CR>', noremap = true, silent = true, desc = 'Previous Tab' },
		{ ']t', ':tabnext<CR>', noremap = true, silent = true, desc = 'Next Tab' },
		{ '<C-t>', ':tabnew<CR>', noremap = true, silent = true, desc = 'New Tab' },
	},

	opts = {
		auto_hide = 1
	},

}
