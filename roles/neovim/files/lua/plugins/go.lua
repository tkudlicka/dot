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

  -- if vim.tbl_contains(filetypes, vim.bo.filetype) then
  --   vim.cmd('doautocmd FileType ' .. vim.bo.filetype)
  -- end

  return go
end
function OrgImports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.cmd [[ autocmd BufWritePre *.go lua OrgImports(1000) ]]
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

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
