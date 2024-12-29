-- Contains snippets

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local go_get_current_fn = function()
	local bufnr = 0
	local parser = vim.treesitter.get_parser(0)
	if not parser then
		return nil
	end

	local tree = parser:parse()[1]
	if not tree then
		return nil
	end

	local root = tree:root()
	if not root then
		return nil
	end

	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(bufnr))
	cursor_row = cursor_row - 1

	local node = root:named_descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
	while node do
		local ty = node:type()
		if ty == "method_declaration" then
			return node
		end
		node = node:parent()
	end

	return nil
end

local go_get_fn_info = function()
	local bufnr = 0

	local function_node = go_get_current_fn()
	if not function_node then
		return nil
	end

	local query = vim.treesitter.query.parse(
		"go",
		[[
(
  (method_declaration
    (parameter_list
      (parameter_declaration
        (identifier) @receiver_identifier
        (_) @receiver_type))
	name: (_) @method_name)
)
    ]]
	)

	local ident, ty, method = nil, nil, nil
	for id, node in query:iter_captures(function_node, bufnr, 0, -1) do
		local name = query.captures[id]
		if name == "receiver_identifier" then
			ident = vim.treesitter.get_node_text(node, bufnr)
		end
		if name == "receiver_type" then
			ty = vim.treesitter.get_node_text(node, bufnr)
		end
		if name == "method_name" then
			method = vim.treesitter.get_node_text(node, bufnr)
		end
	end

	if not ident or not ty or not method then
		return nil
	end

	return { ident, ty, method }
end

local go_format_log = function()
	local found = go_get_fn_info()
	if not found then
		return 'log.Errorf("'
	end

	local ident, ty, method = unpack(found)
	return string.format('%s.log.Errorf("%s.%s ', ident, ty.gsub(ty, "%*", ""), method)
end

ls.add_snippets("go", {
	s("iferr", {
		t("if err != nil {"),
		t({ "", "    return err" }),
		t({ "", "}" }),
	}),

	s("ifit", {
		t("if err != nil {"),
		t({ "", "    return " }),
		i(1),
		t(", err"),
		t({ "", "}" }),
	}),

	s("lg", {
		f(go_format_log),
		i(1),
		t('")'),
	}),
})
