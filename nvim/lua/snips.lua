-- Contains snippets

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

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
		t("m.log.Infof("),
		i(1),
		t(")"),
	}),
})
