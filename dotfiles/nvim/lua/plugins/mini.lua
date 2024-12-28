return {

	'echasnovski/mini.nvim',

	config = function()
		-- require('mini.bracketed').setup()
		require('mini.bufremove').setup()
		require('mini.hipatterns').setup({
			highlighters = {
				fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
				hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
				todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
				note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
				hex_color = require('mini.hipatterns').gen_highlighter.hex_color()
			}
		})
		require('mini.operators').setup()
		-- require('mini.splitjoin').setup({
		-- 	mappings = {
		-- 		toggle = 'gj',
		-- 	},
		-- })
		-- require('mini.surround').setup()
	end,

}
