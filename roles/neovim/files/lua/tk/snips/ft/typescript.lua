require("luasnip.session.snippet_collection").clear_snippets "typescript"

local ls = require "luasnip"

local fmta = require("luasnip.extras.fmt").fmta

local s = ls.snippet
local i = ls.insert_node

ls.add_snippets("typescript", {
  s("cl", fmta("console.log(<value>);", { value = i(1, "") })),
})
