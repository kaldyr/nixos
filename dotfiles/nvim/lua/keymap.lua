local map = vim.keymap.set

-- Cleanup space for leader key usage
map('', '<Space>', '<Nop>')
map('n', 'Q', '<Nop>')

-- Escape removes highlights
map('n', '<ESC>', '<Cmd>nohls<CR>', { silent = true })

-- Line Movement
map('n', '<Down>', '<Cmd>move .+1<CR>==', { silent = true, noremap = true }) -- <Caps-j>
map('n', '<Up>', '<Cmd>move .-2<CR>==', { silent = true, noremap = true }) -- <Caps-k>
map('v', '<Down>', ":move '>+1<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-j>
map('v', '<Up>', ":move '<-2<CR>gv=gv", { silent = true, noremap = true }) -- <Caps-k>

-- Character movement
map('n', '<Left>', '"mxh"mP', { silent = true }) -- <Caps-h>
map('n', '<Right>', '"mx"mp', { silent = true }) -- <Caps-l>

-- Tabs
map('n', '<C-/>', '<Cmd>tabnew<CR>', { desc = 'Create New Tab', silent = true })
map('n', '[t', '<Cmd>tabp<CR>', { desc = 'Swap to Tab left', silent = true })
map('n', ']t', '<Cmd>tabn<CR>', { desc = 'Swap to Tab right', silent = true })

-- Window management
map('n', '<C-w>n', '<Cmd>new<CR>', { desc = 'Split down', silent = true })
map('n', '<C-w>v', '<Cmd>vnew<CR>', { desc = 'Split to right', silent = true })
map('n', '<C-q>', '<Cmd>bd<CR>', { desc = 'Close Buffer', silent = true })
map('n', '<C-w>t', '<Cmd>tabnew<CR>', { desc = 'New Tab', silent = true })

-- Indentation
map('n', '<', '<<', { silent = true, noremap = true })
map('n', '>', '>>', { silent = true, noremap = true })
-- Stay in visual mode after indent
map('v', '<', '<gv', { silent = true })
map('v', '>', '>gv', { silent = true })

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
