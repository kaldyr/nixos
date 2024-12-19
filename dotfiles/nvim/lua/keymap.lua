-- Cleanup space for leader key usage
vim.keymap.set('', '<Space>', '<Nop>')
vim.keymap.set('n', 'Q', '<Nop>')

-- Escape removes highlights
vim.keymap.set('n', '<ESC>', '<Cmd>nohls<CR>', { silent = true })

-- Line Movement
vim.keymap.set('n', '<Down>', '<Cmd>move .+1<CR>==', { silent = true, noremap = true }) -- <Caps-j>
vim.keymap.set('n', '<Up>', '<Cmd>move .-2<CR>==', { silent = true, noremap = true }) -- <Caps-k>
vim.keymap.set('v', '<Down>', ":move '>+1<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-j>
vim.keymap.set('v', '<Up>', ":move '<-2<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-k>

-- Indentation
vim.keymap.set('n', '<', '<<', { silent = true, noremap = true })
vim.keymap.set('n', '>', '>>', { silent = true, noremap = true })
-- Stay in visual mode after indent
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- Character movement
vim.keymap.set('n', '<Left>', '"mxh"mP', { silent = true }) -- <Caps-h>
vim.keymap.set('n', '<Right>', '"mx"mp', { silent = true }) -- <Caps-l>

-- Window management
vim.keymap.set('n', '<C-w>n', '<Cmd>new<CR>', { desc = 'Split down', silent = true })
vim.keymap.set('n', '<C-w>v', '<Cmd>vnew<CR>', { desc = 'Split to right', silent = true })
vim.keymap.set('n', '<C-q>', '<Cmd>bd<CR>', { desc = 'Close Buffer', silent = true })
vim.keymap.set('n', '<C-w>t', '<Cmd>tabnew<CR>', { desc = 'New Tab', silent = true })

-- Execute/Replay Macro over selection
vim.keymap.set('x', '.', '<Cmd>norm .<CR>', { silent = true, noremap = true })
vim.keymap.set('x', '@', '<Cmd>norm @@<CR>', { silent = true, noremap = true })

-- Replace word under cursor
vim.keymap.set(
	'n',
	'<leader>r',
	':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gcI<left><left><left><left>',
	{ desc = '[R]eplace Word under cursor', silent = false }
)

-- Replace selection
vim.keymap.set(
	'v',
	'<leader>r',
	'"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>',
	{ desc = '[R]eplace Selection', silent = false }
)

-- Smart dd - if the line is empty don't override registers
vim.keymap.set(
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
