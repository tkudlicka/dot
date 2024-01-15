vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Complextras.nvim configuration
vim.api.nvim_set_keymap(
  "i",
  "<C-x><C-m>",
  [[<c-r>=luaeval("require('complextras').complete_matching_line()")<CR>]],
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "i",
  "<C-x><C-d>",
  [[<c-r>=luaeval("require('complextras').complete_line_from_cwd()")<CR>]],
  { noremap = true }
)

--[[ vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
-- Add vim-dadbod-completion in sql files
_ = vim.cmd [[
  augroup DadbodSql
    au!
  autocmd filetype mysql echo "DadbodSql"
    autocmd filetype sql,mysql,plsql lua require('cmp').setup.buffer { sources = { { name = 'vim-dadbod-completion' } } }
  augroup END
--]] 
