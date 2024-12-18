return {

	'nvim-telescope/telescope.nvim',

	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		'isak102/telescope-git-file-history.nvim',
		'nvim-telescope/telescope-ui-select.nvim',
		'tpope/vim-fugitive',
	},

	cmd = { 'Telescope' },

	keys = {
		{ '<leader>f:', function() require('telescope.builtin').command_history() end, desc = 'Command History' },
		{ '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Find Buffers' },
		{ '<leader>fc', function() require('telescope.builtin').commands() end, desc = 'Find Commands' },
		{ '<leader>fd', function() require('telescope.builtin').diagnostics() end, desc = 'Find Diagnostics' },
		{ '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
		{ '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Find Grep' },
		{ '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Find Help' },
		{ '<leader>fH', function() require('telescope.builtin').highlights() end, desc = 'Find Highlights' },
		{ '<leader>fk', function() require('telescope.builtin').keymaps() end, desc = 'Find Keymaps' },
		{ '<leader>fm', function() require('telescope.builtin').marks() end, desc = 'Find Marks' },
		{ '<leader>fo', function() require('telescope.builtin').vim_options() end, desc = 'Find Options' },
		{ '<leader>fr', function() require('telescope.builtin').oldfiles() end, desc = 'Recent Files' },
		{ '<leader>fR', function() require('telescope.builtin').resume() end, desc = 'Resume' },
		{ '<leader>fG', function() require('telescope').extensions.git_file_history.git_file_history() end, desc = 'Git File History' },
	},

	opts = {
		extensions = {
			['ui-select'] = {
				function() require('telescope.themes').get_dropdown {} end
			},
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			}
		},
	},

	config = function(_, opts)
		require('telescope').setup(opts)
		require('telescope').load_extension('fzf')
	end

}
