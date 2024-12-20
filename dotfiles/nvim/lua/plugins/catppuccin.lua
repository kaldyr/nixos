return {

	'catppuccin/nvim',
	name = 'catppuccin',

	lazy = false,
	priority = 1000,

	opts = {

		flavour = 'frappe',
		background = {
			light = 'latte',
			dark = 'frappe',
		},

		dim_inactive = {
			enabled = true,
			shade = 'dark',
			percentage = 0.05,
		},

		integrations = {
			barbar = true,
			blink_cmp = true,
			flash = true,
			fzf = true,
			gitsigns = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { 'italic' },
					hints = { 'italic' },
					warnings = { 'italic' },
					information = { 'italic' },
					ok = { 'italic' },
				},
				underlines = {
					errors = { 'underline' },
					hints = { 'underline' },
					warnings = { 'underline' },
					information = { 'underline' },
					ok = { 'underline' },
				},
				inlay_hints = {
					background = true,
				},
			},
			mini = {
				enabled = true,
			},
			noice = true,
			notify = true,
			render_markdown = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
		term_colors = true,
	},

	config = function(_, opts)
		require('catppuccin').setup(opts)
		vim.cmd [[ colorscheme catppuccin ]]
	end

}
