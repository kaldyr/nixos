return {

	'neovim/nvim-lspconfig',

	dependencies = {
		{ 'folke/lazydev.nvim', ft = 'lua', opts = {} },
	},

	event = { 'BufReadPre', 'BufNewFile' },

	config = function()

		local on_attach = function(_, bufnr)
			vim.lsp.inlay_hint.enable( false )
			local map, lb = vim.keymap.set, vim.lsp.buf
			map('n', 'gd', lb.definition, { buffer = bufnr, desc = 'Goto Definition' })
			map('n', 'gD', lb.declaration, { buffer = bufnr, desc = 'Goto Declaration' })
			map('n', 'gI', lb.implementation, { buffer = bufnr, desc = 'Goto Implementation' })
			map('n', 'gr', lb.references, { buffer = bufnr, desc = 'Goto References' })
			map('n', 'gT', lb.type_definition, { buffer = bufnr, desc = 'Goto Type Definition' })
			-- map('n', '<leader>ch', lb.hover, { buffer = bufnr, desc = 'Hover Documenation' })
			-- map('n', '<leader>cs', lb.signature_help, { buffer = bufnr, desc = 'Signature Documenation' })
			-- map('n', '<leader>ca', lb.code_action, { buffer = bufnr, desc = 'Code Action' })
			-- map('n', '<leader>cr', lb.rename, { buffer = bufnr, desc = 'Code Rename' })
			-- map('n', '<leader>ds', lb.document_symbol, { buffer = bufnr, desc = 'Document Symbols' })
			-- map('n', '<leader>wa', lb.add_workspace_folder, { buffer = bufnr, desc = 'Workspace Add Folder' })
			-- map('n', '<leader>wl', lb.list_workspace_folders, { buffer = bufnr, desc = 'Workspace List Folders' })
			-- map('n', '<leader>wr', lb.remove_workspace_folder, { buffer = bufnr, desc = 'Workspace Remove Folder' })
			-- map('n', '<leader>ws', lb.workspace_symbol, { buffer = bufnr, desc = 'Workspace Symbols' })
		end

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend( 'force', capabilities, require('blink.cmp').get_lsp_capabilities())

		vim.filetype.add({ extension = { templ = 'templ' } }) -- a-h/templ Go
		require('lspconfig').cssls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').elixirls.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').gopls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
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
		}
		require('lspconfig').html.setup { on_attach = on_attach, capabilities = capabilities, filetypes = { 'html', 'templ' } }
		require('lspconfig').htmx.setup { on_attach = on_attach, capabilities = capabilities, filetypes = { 'html', 'templ' } }
		require('lspconfig').lua_ls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
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
		}
		require('lspconfig').marksman.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').nixd.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').nushell.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').taplo.setup { on_attach = on_attach, capabilities = capabilities }
		require('lspconfig').templ.setup { on_attach = on_attach, capabilities = capabilities, filetypes = { 'templ' } }
		require('lspconfig').yamlls.setup { on_attach = on_attach, capabilities = capabilities }
		vim.g.markdown_fenced_languages = {'css', 'fish', 'html', 'go', 'javascript', 'json', 'lua', 'nix', 'python', 'sql', 'vim'}

	end

}
