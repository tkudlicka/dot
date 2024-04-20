if not pcall(require, "luasnip") then
  return
end

local make = require("tk.snips").make

local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
  history = false,

  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "NonTest" } },
      },
    },
  },
}

-- create snippet
-- s(context, nodes, condition, ...)
local snippet = ls.s

--  Useful for dynamic nodes and choice nodes
local snippet_from_nodes = ls.sn

-- This is the simplest node.
--  Creates a new text node. Places cursor after node by default.
--  t { "this will be inserted" }
--
--  Multiple lines are by passing a table of strings.
--  t { "line 1", "line 2" }
local t = ls.text_node

-- Insert Node
--  Creates a location for the cursor to jump to.
--      Possible options to jump to are 1 - N
--      If you use 0, that's the final place to jump to.
--
--  To create placeholder text, pass it as the second argument
--      i(2, "this is placeholder text")
local i = ls.insert_node

-- Function Node
--  Takes a function that returns text
local f = ls.function_node

-- This a choice snippet. You can move through with <c-l> (in my config)
--   c(1, { t {"hello"}, t {"world"}, }),
--
-- The first argument is the jump position
-- The second argument is a table of possible nodes.
--  Note, one thing that's nice is you don't have to include
--  the jump position for nodes that normally require one (can be nil)
local c = ls.choice_node

local d = ls.dynamic_node

-- TODO: Document what I've learned about lambda
local l = require("luasnip.extras").lambda

local events = require "luasnip.util.events"

-- local str_snip = function(trig, expanded)
--   return ls.parser.parse_snippet({ trig = trig }, expanded)
-- end

local same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

local toexpand_count = 0

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
ls.add_snippets(nil, {
  snippet(
    { trig = "$$ (.*)", regTrig = true },
    f(function(_, snip, command)
      if snip.captures[1] then
        command = snip.captures[1]
      end

      local file = io.popen(command, "r")
      local res = { "$ " .. snip.captures[1] }
      for line in file:lines() do
        table.insert(res, line)
      end
      return res
    end, {}, "ls"),
    {
      -- Don't show this one, because it's not useful as a general purpose snippet.
      show_condition = function()
        return false
      end,
    }
  ),
})

local js_attr_split = function(args)
  local val = args[1][1]
  local split = vim.split(val, ".", { plain = true })

  local choices = {}
  local thus_far = {}
  for index = 0, #split - 1 do
    table.insert(thus_far, 1, split[#split - index])
    table.insert(choices, t { table.concat(thus_far, ".") })
  end

  return snippet_from_nodes(nil, c(1, choices))
end

local fill_line = function(char)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, row - 2, row, false)
    return string.rep(char, #lines[1])
  end
end

ls.add_snippets(
  "rst",
  make {
    jsa = {
      ":js:attr:`",
      d(2, js_attr_split, { 1 }),
      " <",
      i(1),
      ">",
      "`",
    },

    link = { ".. _", i(1), ":" },

    head = f(fill_line "=", {}),
    sub = f(fill_line "-", {}),
    subsub = f(fill_line "^", {}),

    ref = { ":ref:`", same(1), " <", i(1), ">`" },
  }
)

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/tk/snips/ft/*.lua", true)) do
  loadfile(ft_path)()
end

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

-- shorcut to source my luasnips file again, which will reload my snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")
