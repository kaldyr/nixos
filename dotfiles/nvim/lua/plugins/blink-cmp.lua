return {

	'saghen/blink.cmp',

	dependencies = 'rafamadriz/friendly-snippets',

	lazy = false, -- lazy loading handled internally
	version = 'v0.*', -- use a release tag to download pre-built binaries

	opts = {

		keymap = { preset = 'enter' },

		appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = 'mono'
		},

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

	},

	opts_extend = { "sources.default" }

}
