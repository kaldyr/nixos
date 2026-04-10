return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)

	-- Options
	local o = vim.opt
	-- General
	o.backup = false
	o.clipboard = 'unnamedplus'
	o.compatible = false
	o.encoding = 'utf-8'
	o.swapfile = false
	o.undofile = false
	o.writebackup = false
	-- Appearance
	o.breakindent = true
	o.cursorline = true
	o.laststatus = 0
	o.linebreak = true
	o.number = false
	o.pumblend = 10
	o.pumheight = 10
	o.relativenumber = true
	o.ruler = false
	o.scrolloff = 8
	o.shortmess:append "sfFIWc"
	o.showcmd = false
	o.showmode = true
	o.showtabline = 0
	o.sidescrolloff = 8
	o.termguicolors = true
	o.timeout = true;
	o.timeoutlen = 400
	o.wrap = false
	-- Editing
	o.formatoptions = 'qjl1t'
	o.ignorecase = true
	o.incsearch = true
	o.virtualedit = 'block'

	-- Keymaps
	local map = vim.keymap.set
	-- Cleanup space for leader key usage
	map('', '<Space>', '<Nop>')
	map('n', 'Q', '<Nop>')
	-- Escape removes highlights
	map('n', '<ESC>', '<Cmd>nohls<CR>', { silent = true })
	-- Remap keys that jump into input, since read only
	map('n', 'A', '$', { silent = true })
	map('n', 'I', '^', { silent = true })

	-- Start
	vim.cmd("hi Normal ctermbg=None ctermfg=None guibg=None guifg=None")
	vim.cmd("set cmdheight=0")

	local term_buf = vim.api.nvim_create_buf(true, false)
	local term_io = vim.api.nvim_open_term(term_buf, {})
	vim.api.nvim_buf_set_keymap(term_buf, "n", "q", "<Cmd>q<CR>", {})
	local group = vim.api.nvim_create_augroup("scrollback", {})

	local setCursor = function()
		vim.api.nvim_feedkeys(tostring(INPUT_LINE_NUMBER) .. [[ggzt]], "n", true)
		local line = vim.api.nvim_buf_line_count(term_buf)
		if CURSOR_LINE <= line then
			line = CURSOR_LINE
		end
		line = CURSOR_LINE
		vim.api.nvim_feedkeys(tostring(line - 1) .. [[j]], "n", true)
		vim.api.nvim_feedkeys([[0]], "n", true)
		vim.api.nvim_feedkeys(tostring(CURSOR_COLUMN - 1) .. [[l]], "n", true)
	end

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		buffer = term_buf,
		callback = function()
			local mode = vim.fn.mode()
			if mode == "t" then
				vim.cmd.stopinsert()
				vim.schedule(setCursor)
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		pattern = "*",
		once = true,
		callback = function(ev)
			local current_win = vim.fn.win_getid()
			for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, -2, false)) do
				vim.api.nvim_chan_send(term_io, line)
				vim.api.nvim_chan_send(term_io, "\r\n")
			end
			for _, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, -2, -1, false)) do
				vim.api.nvim_chan_send(term_io, line)
			end
			vim.api.nvim_win_set_buf(current_win, term_buf)
			vim.api.nvim_buf_delete(ev.buf, { force = true })
		end,
	})

	local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		callback = function()
			vim.highlight.on_yank()
		end,
		group = highlight_group,
		pattern = "*",
	})

	vim.defer_fn(setCursor, 10)

end
