return {

	'ibhagwan/fzf-lua',

	dependencies = 'nvim-tree/nvim-web-devicons',

	keys = {
		{ '<leader>b', function() require('fzf-lua').buffers() end, desc = 'Buffer Picker', silent = true },
		{ '<leader>f', function() require('fzf-lua').files() end, desc = 'File Picker', silent = true },
		{ '<leader>h', function() require('fzf-lua').git_bcommits() end, desc = 'Git File History', silent = true },
		{ '<leader>l', function() require('fzf-lua').live_grep() end, desc = 'Search Live Grep', silent = true },
		{ '<leader>q', function() require('fzf-lua').quickfix() end, desc = 'Quickfix Picker', silent = true },
		{ '<leader>Q', function() require('fzf-lua').grep_quickfix({ multiprocess = true }) end, desc = 'Search Quickfix', silent = true },
		{ '<leader>r', function() require('fzf-lua').resume() end, desc = 'Resume Last Picker', silent = true },
		{ '<leader>s', function() require('fzf-lua').grep({ multiprocess = true }) end, desc = 'Search File Contents', silent = true },
		{ '<leader>S', function() require('fzf-lua').grep_cword({ multiprocess = true }) end, desc = 'Search Word Under Cursor', silent = true },
		{ '<leader>t', function() require('fzf-lua').treesitter() end, desc = 'Treesitter Picker', silent = true },
	},

	opts = {
		'default-title',
		fzf_colors = true,
	},

}
