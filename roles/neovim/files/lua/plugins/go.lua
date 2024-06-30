local go_group = vim.api.nvim_create_augroup('go_group', { clear = true })
local utils = require('tk.utils')
local fn = vim.fn

local handlers = {}
local filetypes = { 'go' }

local go = {
  "mfussenegger/nvim-dap",
  ft = filetypes,
}
go.config = function()
  vim.keymap.set('n', '<Plug>(GoConsoleLog)', handlers.console_log)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go' },
    callback = handlers.setup_buffer,
    group = go_group,
  })

  if vim.tbl_contains(filetypes, vim.bo.filetype) then
    vim.cmd('doautocmd FileType ' .. vim.bo.filetype)
  end

  return go
end

function handlers.setup_buffer()
  vim.keymap.set('n', '<Leader>ll', '<Plug>(GoConsoleLog)', { remap = true, buffer = true })
end

function handlers.console_log()
  local view = fn.winsaveview() or {}
  local word = fn.expand('<cword>')
  local node = vim.treesitter.get_node()
  while node and node:type() ~= 'lexical_declaration' do
    node = node:parent()
  end
  if node then
    local _, _, end_line, _ = vim.treesitter.get_node_range(node)
    fn.cursor(end_line + 1, 0)
  end
  local scope = utils.get_gps_scope(word)
  if not scope:match(vim.pesc(word) .. '$') then
    scope = ('%s > %s'):format(scope, word)
  end
  vim.cmd(string.format("keepjumps norm!ofmt.Println(\"%s\", %s)", scope, word))
  fn['repeat#set'](utils.esc('<Plug>(GoConsoleLog)'))
  fn.winrestview(view)
end

return go
