-- Config   --
-- Startup  -->
-- vim:fdm=marker:fdl=0:foldmarker=-->,<--

local g, o = vim.g, vim.opt

-- Cache compiled lua
vim.loader.enable()

-- Disable built-in plugins
g.loaded_gzip = 1
g.loaded_matchit = 1
g.loaded_netrw = 1
g.loaded_tarPlugin = 1
g.loaded_tohtml = 1
g.loaded_tutor = 1
g.loaded_zipPlugin = 1

-- Get the grammars
o.rtp:append( vim.fn.stdpath('data') .. '/grammars' )

-- Delay clipboard until UiEnter for startup time
vim.schedule( function() o.clipboard = 'unnamedplus' end )

--<--
-- Options  -->
-- Define the Leader Key
g.mapleader = ' '
g.maplocalleader = ' '

-- General
o.backup = false
o.encoding = 'utf-8'
o.mouse = 'a'
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.undofile = true
o.writebackup = false

-- Appearance
o.breakindent = true
o.concealcursor = 'nc'
o.conceallevel = 2
o.cursorline = true
o.laststatus = 3
o.linebreak = true
o.number = true
o.pumblend = 10
o.pumheight = 10
o.relativenumber = true
o.ruler = false
o.scrolloff = 8
o.shortmess:append 'sfFIWc'
o.showmode = false
o.showtabline = 0
o.sidescrolloff = 8
o.signcolumn = 'yes'
o.syntax = 'on'
o.timeout = true
o.timeoutlen = 400
o.title = true
o.updatetime = 250
o.wrap = false

-- Editing
o.formatoptions = 'qjl1t'
o.ignorecase = true
o.inccommand = 'split'
o.incsearch = true
o.infercase = true
o.smartcase = true
o.spelllang = 'en_us'
o.virtualedit = 'block'

-- Folding
o.foldcolumn = 'auto:1'
o.foldenable = true
o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
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

o.list = true
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

-- Fenced languages
g.markdown_fenced_languages = {
	'css',
	'fish',
	'go',
	'html',
	'javascript',
	'json',
	'lua',
	'nix',
	'python',
	'sql',
	'vim',
}

--<--
-- Keymaps  -->
local map = vim.keymap.set

-- Cleanup space for leader key usage
map('', '<Space>', '<Nop>')
map('n', 'Q', '<Nop>')

-- Escape removes highlights
map('n', '<ESC>', '<Cmd>nohls<CR>', { silent = true })

-- LSP
map('n', 'gd', vim.lsp.buf.definition, { silent = true, noremap = true })
map('n', 'gD', vim.lsp.buf.declaration, { silent = true, noremap = true })

-- Line Movement
map('n', '<Down>', '<Cmd>move .+1<CR>==', { silent = true, noremap = true }) -- <Caps-j>
map('n', '<Up>', '<Cmd>move .-2<CR>==', { silent = true, noremap = true }) -- <Caps-k>
map('v', '<Down>', ":move '>+1<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-j>
map('v', '<Up>', ":move '<-2<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-k>

-- Character movement
map('n', '<Left>', '"mxh"mP', { silent = true }) -- <Caps-h>
map('n', '<Right>', '"mx"mp', { silent = true }) -- <Caps-l>

-- Window management
map('n', '<C-x>', '<Cmd>bd<CR>', { desc = 'Close Buffer', silent = true })
map('n', '<C-h>', ':wincmd h<CR>', { desc = 'Window Left', silent = true })
map('n', '<C-j>', ':wincmd j<CR>', { desc = 'Window Down', silent = true })
map('n', '<C-k>', ':wincmd k<CR>', { desc = 'Window Up', silent = true })
map('n', '<C-l>', ':wincmd l<CR>', { desc = 'Window Right', silent = true })

-- Indentation
map('n', '<', '<<', { silent = true, noremap = true })
map('n', '>', '>>', { silent = true, noremap = true })

-- Stay in visual mode after indent
map('v', '<', '<gv', { silent = true })
map('v', '>', '>gv', { silent = true })

-- Folding
map('n', 'Z', 'zA', { desc = 'Toggle folds at cursor', silent = true })
map('n', '\\z', 'zi', { desc = 'Toggle folding', silent = true })

-- Execute/Replay Macro over selection
map('x', '.', ':norm .<CR>', { silent = true, noremap = true })
map('x', '@', ':norm @@<CR>', { silent = true, noremap = true })

-- Replace word under cursor
map(
	'n',
	'<C-r>',
	':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<left><left><left><left>',
	{ desc = 'Replace Word under cursor', silent = false }
)

-- Replace selection
map(
	'v',
	'<C-r>',
	'"hy:%s/<C-r>h/<C-r>h/gcI<left><left><left>',
	{ desc = 'Replace Selection', silent = false }
)

-- Smart dd - if the line is empty don't override registers
map(
	'n',
	'dd',
	function()
		if vim.api.nvim_get_current_line():match('^%s*$') then
			return '"_dd'
		end
		return 'dd'
	end,
	{ expr = true }
)

-- Toggle between words or symbols
map(
	'n',
	'T',
	function()
		local toggles = {
			["true"] = "false",
			["always"] = "never",
			["yes"] = "no",
			["1"] = "0",
			["on"] = "off",
			["&&"] = "||",
			["+"] = "-",
		}

		local cword = vim.fn.expand("<cword>")
		local newWord
		for word, opposite in pairs(toggles) do
			if cword == word then
				newWord = opposite
			end
			if cword == opposite then
				newWord = word
			end
		end
		if newWord then
			local prevCursor = vim.api.nvim_win_get_cursor(0)
			vim.cmd.normal({ '"_ciw' .. newWord, bang = true })
			vim.api.nvim_win_set_cursor(0, prevCursor)
		end
	end,
	{ desc = 'Toggle between words or symbols', silent = true }
)

--<--
-- Autocmd  -->

local ac = function( event, pattern, callback )
	vim.api.nvim_create_autocmd(event, {
		pattern = pattern,
		callback = callback
	})
end

-- Stuff to set whenever first entering neovim
ac( 'VimEnter', '*', function()

	-- Set the current working directory to the path of the file passed to neovim
	local pwd = vim.fn.expand('%:p:h')
	vim.api.nvim_set_current_dir(pwd)

	-- If neovim opened a folder instead of a file, close the buffer
	if string.sub(vim.fn.expand('%p'), 0, -1) == pwd then
		vim.api.nvim_buf_delete(0, { force = true })
	end

	-- Default options
	vim.cmd [[ filetype plugin indent on ]]

end )

-- Open help on the side
ac( 'FileType', 'help', function()
	vim.cmd [[wincmd L]]
end )

-- Highlight yanked text
ac( 'TextYankPost', '*', function()
	vim.highlight.on_yank()
end )

--<--
-- LSP      --
-- Golang   -->

vim.lsp.config( 'gopls', {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	settings = {
		gopls = {
			analyses = {
				shadow = true,
				unusedwrite = true,
				unuseedvariable = true,
				unusedparams = true,
			},
			-- codelenses = {
			-- 	generate = false,
			-- 	gc_details = true,
			-- 	regenerate_cgo = true,
			-- 	tidy = true,
			-- 	upgrade_dimependency = true,
			-- 	vendor = false,
			-- },
			-- completeUnimported = true,
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			staticcheck = true,
			usePlaceholders = true,
		},
	},
})

vim.lsp.enable('gopls')

--<--
-- Html     -->

vim.lsp.config( 'html', {
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { 'html', 'templ' },
	settings = {},
	init_options = {
		provideFormatter = false,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { 'html', 'css', 'javascript' },
	},
})

vim.lsp.enable('html')

--<--
-- Lua      -->

vim.lsp.config( 'lua_ls', {
	cmd = { 'lua-language-server' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	},
	filetypes = { 'lua' },
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
			codeLens = {
				enable = true,
			},
			completion = {
				callSnippet = "Replace",
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "Enable",
				semicolon = "Enable",
				arrayIndex = "Disable",
			},
		},
	},
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
})

vim.lsp.enable('lua_ls')

--<--
-- Markdown -->

vim.lsp.config( 'marksman', {
	cmd = { 'marksman' },
	filetypes = { 'md' },
})

vim.lsp.enable('marksman')

--<--
-- Nix      -->

vim.lsp.config( 'nixd', {
	cmd = { 'nixd' },
	filetypes = { 'nix' },
})

vim.lsp.enable('nixd')

--<--
-- Templ    -->

vim.lsp.config( 'templ', {
	cmd = { 'templ' },
	filetypes = { 'templ' },
})

vim.lsp.enable('templ')

--<--
-- Yaml     -->

vim.lsp.config( 'yamlls', {
	cmd = { 'yaml-language-server' },
	filetypes = { 'yaml' },
})

vim.lsp.enable('yamlls')

--<--
-- Plugins  --
-- Install  -->

local gh = function(repo) return 'https://github.com/' .. repo end
---@type (string|vim.pack.Spec)[]
vim.pack.add({
	{ src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
	{ src = gh 'catppuccin/nvim', name = 'catppuccin' },
	gh 'rafamadriz/friendly-snippets',
	gh 'ibhagwan/fzf-lua',
	gh 'lewis6991/gitsigns.nvim',
	gh 'folke/lazydev.nvim',
	gh 'nvim-lualine/lualine.nvim',
	gh 'yavorski/lualine-macro-recording.nvim',
	gh 'echasnovski/mini.nvim',
	gh 'nvim-treesitter/nvim-treesitter-context',
	gh 'nvim-tree/nvim-web-devicons',
	gh 'epwalsh/obsidian.nvim',
	gh 'nvim-lua/plenary.nvim',
	gh 'MeanderingProgrammer/render-markdown.nvim',
	gh 'folke/snacks.nvim',
	gh 'rachartier/tiny-inline-diagnostic.nvim',
	gh 'Wansmer/treesj',
	gh 'folke/which-key.nvim',
	gh 'mikavilpas/yazi.nvim',
})

--<--
-- Catppuccin             -->  Colorscheme

require('catppuccin').setup({

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
		types = { 'bold', 'italic' },
	},

	term_colors = true,

})

vim.cmd [[ colorscheme catppuccin ]]

--<--
-- Blink.cmp              -->  Completion

vim.schedule( function()

	require('blink.cmp').setup({

		keymap = { preset = 'enter' },

		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = { documentation = { auto_show = true } },

		sources = {
			default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
			providers = {
				lazydev = {
					name = 'LazyDev',
					module = 'lazydev.integrations.blink',
					score_offset = 100,
				},
			},
		},

		fuzzy = { implementation = 'lua' }

	})

end )

--<--
-- Fzf-lua                -->  Fuzzy Pickers

vim.schedule( function()

	require('fzf-lua').setup({

		file_ignore_patterns = {
			"%.nextcloudsync.log",
			"%.obsidian/",
			"%.sync_.*%.db.*",
			"%.trash/",
		},

		grep = {
			prompt = 'Grep> ',
			input_prompt = 'Grep For> ',
			multiprocess = true,
			git_icons = true,
			file_icons = true,
			color_icons = true,
		},

	})

	map( 'n', '<leader>b', function() require('fzf-lua').buffers() end, { silent = true, desc = 'Buffer Picker' } )
	map( 'n', '<leader>f', function() require('fzf-lua').files() end, { silent = true, desc = 'File Picker' } )
	map( 'n', '<leader>h', function() require('fzf-lua').git_bcommits() end, { silent = true, desc = 'Git History Picker' } )
	map( 'n', '<leader>q', function() require('fzf-lua').quickfix() end, { silent = true, desc = 'Quickfix Picker' } )
	map( 'n', '<leader>Q', function() require('fzf-lua').lgrep_quickfix({ multiprocess = true }) end, { silent = true, desc = 'Search Quickfix' } )
	map( 'n', '<leader>r', function() require('fzf-lua').resume() end, { silent = true, desc = 'Resume last Picker' } )
	map( 'n', '<leader>s', function() require('fzf-lua').grep() end, { silent = true, desc = 'Search file contents' } )
	map( 'n', '<leader>l', function() require('fzf-lua').live_grep_native() end, { silent = true, desc = 'Live grep file contents' } )
	map( 'n', '<leader>L', function() require('fzf-lua').live_grep_resume() end, { silent = true, desc = 'Resume live grep' } )

end )

--<--
-- Gitsigns               -->  Indicators for git changes

vim.schedule( function()

	require('gitsigns').setup({

		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '⨫' },
			untracked = { text = '┆' },
		},

		preview_config = {
			border = 'rounded',
			style = 'minimal',
		},

		on_attach = function(bufnr)
			require('which-key').add({ ' g', group = 'Git Actions' })
			local gs = require('gitsigns')
			map('n', '[g', function() gs.nav_hunk('prev') end, { buffer = bufnr, desc = 'Jump to previous Git hunk' })
			map('n', ']g', function() gs.nav_hunk('next') end, { buffer = bufnr, desc = 'Jump to next Git hunk' })
			map('n', '<leader>gs', gs.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
			map('n', '<leader>gS', gs.stage_buffer, { buffer = bufnr, desc = 'Stage entire buffer' })
			map('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
			map('n', '<leader>gR', gs.reset_buffer, { buffer = bufnr, desc = 'Reset buffer' })
			map('n', '<leader>gp', gs.preview_hunk, { buffer = bufnr, desc = 'Preview hunk' })
			map('n', '<leader>gb', gs.blame_line, { buffer = bufnr, desc = 'Show blame information' })
			map('n', '<leader>gD', gs.diffthis, { buffer = bufnr, desc = 'Diff buffer' })
			map('n', '<leader>gT', gs.toggle_current_line_blame, { buffer = bufnr, desc = 'Toggle current blame' })
			map('n', '<leader>gd', gs.preview_hunk_inline, { buffer = bufnr, desc = 'Toggle deleted' })
		end,

	})

end )

--<--
-- Lazydev                -->  Teach lua lsp about neovim

ac( 'Filetype', 'lua', function()

	require('lazydev').setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		}
	})

end )

--<--
-- Lualine                -->  Status line

require('lualine').setup({

	options = {
		show_filename_only = false,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' }
	},

	sections = {
		lualine_a = {
			{ 'mode', separator = { left = '█', right = '' }, right_padding = 2 },
			{ 'macro_recording', '%s' },
		},
		lualine_b = { 'branch', 'diff' },
		lualine_c = {
			{ 'filename', path = 1 },
		},
		lualine_x = { 'diagnostics' },
		lualine_y = { 'filetype' },
		lualine_z = {
			{ 'location', separator = { left = '', right = '█' }, left_padding = 2 },
		}
	}

})

--<--
-- Mini                   -->  Collection of mini plugins

vim.schedule( function() require('mini.ai').setup() end )

vim.schedule( function()

	require('mini.hipatterns').setup({
		highlighters = {
			fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
			hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
			todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
			note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
			hex_color = require('mini.hipatterns').gen_highlighter.hex_color()
		}
	})

end )

--<--
-- Which-key              -->  What was that key again?

vim.schedule( function()

	require('which-key').setup({ preset = 'helix' })

	require('which-key').add({
		{ '\\', group = 'Toggle' },
		{ ' ', group = 'Pickers' },
	})

	map(
		'n',
		'<leader>?',
		function()
			require('which-key').show({ global = false })
		end,
		{ desc = 'Buffer Local Keymaps (which-key)' }
	)

end )

--<--
-- Obsidian               -->  Work with Obsidian vaults

ac( 'Filetype', 'markdown', function()

	require('obsidian').setup({

		finder = 'fzf-lua',

		mappings = {
			['gf'] = {
				action = function()
					return require('obsidian').util.gf_passthrough()
				end,
				opts = { buffer = true, expr = true, noremap = false },
			},
			['<cr>'] = {
				action = function()
					return require('obsidian').util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},

		ui = {
			enable = false,
			checkboxes = {
				[' '] = { hl_group = 'ObsidianTodo' },
				['x'] = { hl_group = 'ObsidianDone' },
			},
		},

		workspaces = {
			{ name = 'Notes', path = vim.fn.expand '~' .. '/Notes' },
			{
				name = "no-vault",
				path = function()
					return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
				end,
				overrides = {
					nodes_subdir = vim.NIL,
					new_notes_location = "current_dir",
					templates = {
						folder = vim.NIL,
					},
					disable_frontmatter = true,
				},
			},
		},
	})

end )

--<--
-- Render Markdown        -->  Make markdown look great

ac( 'Filetype', 'markdown', function()

	require('render-markdown').setup({
		anti_conceal = {
			enabled = false,
		},
	})

	map( 'n', '\\m', '<Cmd>RenderMarkdown toggle<CR>', { desc = "Toggle 'RenderMarkdown'", silent = true } )

end )

--<--
-- Snacks                 -->  Collection of tiny plugins

require('snacks').setup({

	bigfile = { enabled = true },
	bufdelete = { enabled = true },
	debug = { enabled = true },
	dim = { enabled = true },
	image = { enabled = true },
	indent = {
		enabled = true,
		indent = {
			char = "🢒", -- Set if using chunk
			-- char = "│", -- Set if not using chunk
		},
		scope = {
			char = "│",
		},
		chunk = {
			enabled = true,
			char = {
				corner_top = "╭",
				corner_bottom = "╰",
			},
			hl = { 'SnacksIndentChunk' },
			only_current = true,
		},
	},
	lazygit = { configure = true },
	notifier = { enabled = true },
	scope = { enabled = true },
	scroll = {
		enabled = true,
		animate = {
			duration = {
				step = 15,
				total = 150,
			},
		},
	},
	statuscolumn = {
		enable = true,
		folds = { open = true },
	},
	toggle = {
		enabled = true,
		color = {
			enabled = "green",
			disabled = "red",
		},
		notify = true,
		which_key = true,
	},
	words = { enabled = true },

})

vim.schedule( function()
	local t = require('snacks.toggle')
	t.diagnostics():map('\\d')
	t.inlay_hints():map('\\h')
	t.line_number({ name = 'Line Number' }):map('\\n')
	t.option('background', { on = 'dark', off = 'light', name = 'Dark Mode' }):map('\\b')
	t.option('cursorcolumn', { name = 'Highlight Cursor Column' }):map('\\C')
	t.option('cursorline', { name = 'Highlight Cursor Line' }):map('\\c')
	t.option('list', { name = 'List Characters' }):map('\\l')
	t.option('relativenumber', { name = 'Relative Number' }):map('\\r')
	t.option('spell', { name = 'Spelling' }):map('\\s')
	t.option('wrap', { name = 'Wrap' }):map('\\w')
	map( 'n', '<leader>z', function() Snacks.lazygit() end, { noremap = true, silent = true, desc = 'Lazygit' } )
end )

--<--
-- Tiny Inline Diagnostic --> Nice looking diagnostics

vim.schedule( function()

	require('tiny-inline-diagnostic').setup()
	vim.diagnostic.config({ virtual_text = false })

end )

--<--
-- Treesj                 --> Split/join

vim.schedule( function()

	require('treesj').setup({
		use_default_keymaps = false,
		max_join_length = 240,
	})

	map( 'n', '<leader>j', function() require('treesj').toggle() end, { desc = 'Toggle Join/Split code block' } )

end )

--<--
-- Yazi                   -->  The best file manager

vim.schedule( function()

	require('yazi').setup({
		floating_window_scaling_factor = 0.8
	})

	map( 'n', '<leader>y', '<Cmd>Yazi cwd<CR>', { desc = 'Yazi File Manager' } )

end )

--<--
