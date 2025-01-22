local acgr = vim.api.nvim_create_augroup( 'AutocmdGroup', {} )
local ac = function( event, pattern, callback )
	vim.api.nvim_create_autocmd( event, { group = acgr, pattern = pattern, callback = callback } )
end

-- Stuff to set whenever first entering neovim
ac( 'VimEnter', '*', function()

	-- Set the current working directory to the path of the file passed to neovim
	local pwd = vim.fn.expand('%:p:h')
	vim.api.nvim_set_current_dir(pwd)

	-- If neovim opened a folder instead of a file, close the buffer and open telescope find_files
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
