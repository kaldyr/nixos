return {

	'ibhagwan/fzf-lua',

	dependencies = {
		'nvim-tree/nvim-web-devicons',
		-- 'echasnovski/mini.icons',
	},

	keys = {
		{ '<leader>f', function() require('fzf-lua').files() end, desc = 'File Picker', silent = true },
		{ '<leader>h', function() require('fzf-lua').git_bcommits() end, desc = 'Git File History', silent = true },
		{ '<leader>sw', function() require('fzf-lua').grep_cword() end, desc = 'Search Word Under Cursor', silent = true },
		{ '<leader>sq', function() require('fzf-lua').grep_quickfix() end, desc = 'Search Quickfix', silent = true },
		{ '<leader>q', function() require('fzf-lua').quickfix() end, desc = 'Quickfix Picker', silent = true },
		{ '<leader>t', function() require('fzf-lua').treesitter() end, desc = 'Treesitter Picker', silent = true },
	},

	opts = {},

}
