-- Define the Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General
vim.opt.clipboard = 'unnamedplus'
vim.opt.conceallevel = 2
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = false
vim.opt.ruler = false
vim.opt.scrolloff = 8
vim.opt.showtabline = 0
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.spelllang = 'en_us'
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.syntax = 'on'
vim.opt.termguicolors = true
vim.opt.timeout = true;
vim.opt.timeoutlen = 400
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wrap = false
vim.opt.shortmess:append "sfFI"

-- Folding
vim.opt.foldcolumn = 'auto:1'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldnestmax = 10
vim.opt.foldtext = ''

-- Default Indenting, use .editorconfig for projects
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.smartindent = false
vim.opt.smarttab = false
vim.opt.softtabstop = -1
vim.opt.tabstop = 3

-- Special characters
vim.opt.fillchars = {
	eob = ' ',
	fold = ' ',
	foldopen = '',
	foldsep = ' ',
	foldclose = '',
}

vim.opt.listchars = {
	extends = '⟩',
	lead = '·',
	leadmultispace = '▏   ',
	nbsp = '␣',
	precedes = '⟨',
	space = '·',
	tab = '▏ ',
	trail = '␣',
}
