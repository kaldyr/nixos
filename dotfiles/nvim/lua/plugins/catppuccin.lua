return {

	'catppuccin/nvim',
	name = 'catppuccin',

	lazy = false,
	priority = 1000,

	opts = {

		flavour = 'auto',

		background = {
			dark = 'frappe',
			light = 'latte',
		},

		custom_highlights = function(colors)
			return {
				LineNr = { fg = colors.surface0 },
				CursorLineNr = { fg = colors.sky, style = { 'bold' } },
				TSCurrentScope = { bg = colors.crust },
				['@property'] = { fg = colors.blue },
			}
		end,

		dim_inactive = {
			enabled = true,
			percentage = 0.05,
			shade = 'dark',
		},

		integrations = {
			barbar = true,
			blink_cmp = true,
			flash = true,
			fzf = true,
			gitsigns = true,
			mini = { enabled = true, },
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { 'italic' },
					hints = { 'italic' },
					information = { 'italic' },
					ok = { 'italic' },
					warnings = { 'italic' },
				},
				underlines = {
					errors = { 'underline' },
					hints = { 'underline' },
					information = { 'underline' },
					ok = { 'underline' },
					warnings = { 'underline' },
				},
				inlay_hints = {
					background = true,
				},
			},
			noice = true,
			render_markdown = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},

		styles = {
			booleans = { 'bold', 'italic' },
			comments = { 'italic' },
			conditionals = { 'bold' },
			functions = { 'bold' },
			keywords = { 'italic' },
			loops = { 'bold' },
			operators = { 'bold' },
			-- properties = { 'italic' },
			types = { 'bold', 'italic' },
		},

		term_colors = true,

	},

	config = function(_, opts)
		require('catppuccin').setup(opts)
		vim.cmd [[ colorscheme catppuccin ]]
	end

}
