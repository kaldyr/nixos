return {

	'neovim/nvim-lspconfig',

	dependencies = {
		{ 'folke/lazydev.nvim', ft = 'lua', opts = {} },
	},

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()
		local on_attach = function(_, bufnr)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Goto Definition' })
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Goto Declaration' })
			vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = bufnr, desc = 'Goto Implementation' })
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'Goto References' })
			vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { buffer = bufnr, desc = 'Goto Type Definition' })
			vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Hover Documenation' })
			vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature Documenation' })
			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Code Action' })
			vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Code Rename' })
			vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, { buffer = bufnr, desc = 'Document Symbols' })
			vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = 'Workspace Add Folder' })
			vim.keymap.set('n', '<leader>wl', vim.lsp.buf.list_workspace_folders, { buffer = bufnr, desc = 'Workspace List Folders' })
			vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = 'Workspace Remove Folder' })
			vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = 'Workspace Symbols' })
		end

		local capabilities = require('blink.cmp').get_lsp_capabilities()
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		vim.filetype.add({ extension = { templ = 'templ' } }) -- a-h/templ Go
		require('lspconfig').cssls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').gopls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').html.setup { on_attach = on_attach, capabilities = capabilities, filetypes = { 'html', 'templ' } }
		require('lspconfig').htmx.setup { on_attach = on_attach, capabilities = capabilities, filetypes = { 'html', 'templ' } }
		require('lspconfig').lua_ls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').marksman.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').nil_ls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').nushell.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').taplo.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').templ.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').yamlls.setup { on_attach = on_attach, capabilities = capabilities }
		vim.g.markdown_fenced_languages = {'css', 'fish', 'html', 'go', 'javascript', 'json', 'lua', 'nix', 'python', 'sql', 'vim'}
	end

}
