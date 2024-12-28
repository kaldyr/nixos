local o, g = vim.opt, vim.g

-- Define the Leader Key
g.mapleader = ' '
g.maplocalleader = ' '

-- General
o.backup = false
o.clipboard = 'unnamedplus'
o.mouse = 'a'
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.undofile = true
o.writebackup = false

-- Appearance
o.breakindent = true
o.conceallevel = 2
o.cursorline = true
o.laststatus = 3
o.linebreak = true
o.number = true
o.pumblend = 10
o.pumheight = 10
o.ruler = false
o.scrolloff = 8
o.shortmess:append "sfFIWc"
o.showmode = false
o.showtabline = 0
o.sidescrolloff = 8
o.signcolumn = 'yes'
o.syntax = 'on'
o.timeout = true;
o.timeoutlen = 400
o.title = true
o.wrap = false

-- Editing
o.formatoptions = 'qjl1t'
o.ignorecase = true
o.incsearch = true
o.infercase = true
o.smartcase = true
o.spelllang = 'en_us'
o.virtualedit = 'block'

-- Folding
o.foldcolumn = 'auto:1'
o.foldenable = true
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = 'expr'
o.foldnestmax = 10
o.foldtext = ''

-- Default Indenting, use .editorconfig for projects
o.autoindent = true
o.expandtab = false
o.shiftwidth = 0
o.smartindent = false
o.smarttab = false
o.softtabstop = -1
o.tabstop = 3

-- Special characters
o.fillchars = {
	eob = ' ',
	fold = ' ',
	foldclose = '',
	foldopen = '',
	foldsep = ' ',
}

o.listchars = {
	extends = '⟩',
	lead = '·',
	leadmultispace = '🢒   ',
	nbsp = '␣',
	precedes = '⟨',
	space = '·',
	tab = '🢒 ',
	trail = '·',
}
