; extends

(const_spec
  name: (identifier) @_name
  value: (expression_list
		   ((raw_string_literal
			  (raw_string_literal_content) @injection.content))
  (#match? @_name "query")
  (#set! injection.language "sql")))
