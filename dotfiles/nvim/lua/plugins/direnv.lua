return {

	'actionshrimp/direnv.nvim',

	opts = {
		async = true,
		on_direnv_finished = function ()
			vim.cmd("LspStart")
			vim.keymap.set('n', '\\~', function() Snacks.terminal.toggle("live-builder") end, { noremap = true, silent = true, desc = 'Toggle Live Builder' })
		end
	}

}
