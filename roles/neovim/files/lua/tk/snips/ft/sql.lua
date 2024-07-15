require("luasnip.session.snippet_collection").clear_snippets "sql"

local ls = require "luasnip"

local fmta = require("luasnip.extras.fmt").fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets("sql", {
  s("sel", fmta("select * from <table>", { table = i(1, "") })),
})
