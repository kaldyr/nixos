return {
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
