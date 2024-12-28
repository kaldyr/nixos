return {

	'aaronik/treewalker.nvim',

	keys = {
		{ '<C-h>', '<Cmd>Treewalker Left<CR>', mode = { 'n', 'x' }, noremap = true, silent = true, desc = 'Treewalker Left' },
		{ '<C-j>', '<Cmd>Treewalker Down<CR>', mode = { 'n', 'x' }, noremap = true, silent = true, desc = 'Treewalker Down' },
		{ '<C-k>', '<Cmd>Treewalker Up<CR>', mode = { 'n', 'x' }, noremap = true, silent = true, desc = 'Treewalker Up' },
		{ '<C-l>', '<Cmd>Treewalker Right<CR>', mode = { 'n', 'x' }, noremap = true, silent = true, desc = 'Treewalker Right' },
		{ '<C-Left>', ':TSTextobjectSwapPrevious @parameter.inner<CR>', noremap = true, silent = true, desc = 'Treesitter Swap Previous' },
		{ '<C-Down>', '<cmd>Treewalker SwapDown<CR>', noremap = true, silent = true, desc = 'Treewalker Swap Down' },
		{ '<C-Up>', '<cmd>Treewalker SwapUp<CR>', noremap = true, silent = true, desc = 'Treewalker Swap Up' },
		{ '<C-Right>', ':TSTextobjectSwapNext @parameter.inner<CR>', noremap = true, silent = true, desc = 'Treesitter Swap Next' },
	},

	opts = {
		highlight = true,
		highlight_duration = 250,
	},

}
