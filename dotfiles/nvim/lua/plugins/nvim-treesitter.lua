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
		textobjects = {
			move = {
				enable = true,
				goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
				goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
				goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
				goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
			},
		},
	},

}
