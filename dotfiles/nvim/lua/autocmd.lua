-- Stuff to set whenever first entering neovim
vim.api.nvim_create_autocmd('VimEnter', {
	pattern = '*',
	callback = function()
		-- Set the current working directory to the path of the file passed to neovim
		local pwd = vim.fn.expand('%:p:h')
		vim.api.nvim_set_current_dir(pwd)

		-- If neovim opened a folder instead of a file, close the buffer and open telescope find_files
		if string.sub(vim.fn.expand('%p'), 0, -1) == pwd then
			vim.api.nvim_buf_delete(0, { force = true })
			require('telescope.builtin').find_files()
		end
	end,
})

-- Open help on the side
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'help',
	command = 'wincmd L'
})
