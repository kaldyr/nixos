(call_expression
	(selector_expression
	field: (field_identifier) @field (#any-of? @field "Exec" "NamedExec" "QueryRow" "Select" "Get" "Query"))
	(argument_list
		([
			(raw_string_literal (raw_string_literal_content) @injection.content)
			(interpreted_string_literal (interpreted_string_literal_content) @injection.content)
		])
		(#set! injection.language "sql")
	)
)
