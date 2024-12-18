return {

	'MeanderingProgrammer/render-markdown.nvim',

	ft = 'markdown',

	keys = {
		{ '\\m', '<Cmd>RenderMarkdown toggle<CR>', desc = "Toggle 'RenderMarkdown'", silent = true },
	},

	opts = {
		file_types = { 'markdown' },
		render_modes = { 'n', 'c', 't' }
	},

}
