-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require 'options'
require 'keymap'
require 'autocmd'

vim.lsp.enable({
	'html',
	'lua_ls',
	'marksman',
	'nixd',
	'templ',
	'yamlls',
})
vim.g.markdown_fenced_languages = {'css', 'fish', 'html', 'go', 'javascript', 'json', 'lua', 'nix', 'python', 'sql', 'vim'}

require('lazy').setup({
	performance = {
		rtp = {
			-- Grammars folder in data is generated from Nix
			paths = { vim.fn.stdpath('data') .. '/grammars' },
			disabled_plugins = {
				'gzip',
				'matchit',
				'netrw',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin'
			},
		},
	},
	spec = { import = 'plugins' }
})
