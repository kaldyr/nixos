return {

	'nvim-treesitter/nvim-treesitter',
	main = 'nvim-treesitter.configs',

	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
		'nvim-treesitter/nvim-treesitter-textobjects',
	},

	opts = {
		auto_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		parser_install_dir = vim.fn.stdpath('data') .. '/grammars/parser', -- Folder controlled by Nix, contains all grammars
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<C-space>',
				node_incremental = '<C-space>',
				scope_incremental = false,
				node_decremental = '<BS>',
			},
		},
	},

}
