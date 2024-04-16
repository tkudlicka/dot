vim.g.mapleader = " "
vim.api.nvim_set_option("clipboard","unnamed")
-- Commenting
-- Map save to Ctrl + S
vim.keymap.set('', '<c-s>', ':w<CR>', { remap = true, silent = true })
vim.keymap.set('i', '<c-s>', '<C-o>:w<CR>', { remap = true, silent = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', '<Leader>c', 'gcc', { remap = true })
vim.keymap.set('v', '<Leader>c', 'gc', { remap = true })

-- Stay on same position when searching word under cursor
vim.keymap.set('n', '*', '*N')
vim.keymap.set('n', '#', '#N')
vim.keymap.set('n', 'g*', 'g*N')
vim.keymap.set('n', 'g#', 'g#N')
vim.keymap.set('x', '*', [["yy/\V<C-R>=escape(getreg('y'), '\/[]')<CR><CR>N]])
vim.keymap.set('x', '#', [["yy?\V<C-R>=escape(getreg('y'), '\/[]')<CR><CR>N]])
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>r", ":%s///g<Left><Left>")
vim.keymap.set("n", "<leader>rv", ":%s///gc<Left><Left><Left>")

vim.keymap.set("v", "<leader>r", ":s///g<Left><Left>")
vim.keymap.set("v", "<leader>rv", ":s///gc<Left><Left><Left>")

-- toggle quickfix list
vim.keymap.set("n", "<leader>c", ":cclose<CR>")
vim.keymap.set("x", "<leader>c", "")
-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dp]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
local mappings = {}
vim.keymap.set('n', '<leader>T', function()
  return mappings.toggle_terminal()
end)
vim.keymap.set('t', '<leader>T', '<C-\\><C-n><C-w>c')

vim.keymap.set('n', 'gs', ':%s/')
vim.keymap.set('x', 'gs', ':s/')
vim.keymap.set('n', 'gx', function()
  vim.cmd([[
    unlet! g:loaded_netrw
    unlet! g:loaded_netrwPlugin
    runtime! plugin/netrwPlugin.vim
  ]])
  return vim.fn['netrw#BrowseX'](vim.fn.expand('<cfile>'), vim.fn['netrw#CheckIfRemote']())
end, { silent = true })

local function close_buffer(bang)
  if vim.bo.buftype ~= '' then
    return vim.cmd.q({ bang = true })
  end

  local windowCount = vim.fn.winnr('$')
  local totalBuffers = #vim.fn.getbufinfo({ buflisted = 1 })
  local noSplits = windowCount == 1
  bang = bang and '!' or ''
  if totalBuffers > 1 and noSplits then
    local command = 'bp'
    if vim.fn.buflisted(vim.fn.bufnr('#')) then
      command = command .. '|bd' .. bang .. '#'
    end
    return vim.cmd(command)
  end
  return vim.cmd('q' .. bang)
end

local function open_file_on_line_and_column()
  local path = vim.fn.expand('<cfile>')
  local line = vim.fn.getline('.')
  local row = 1
  local col = 1
  if vim.fn.match(line, vim.fn.escape(path, '/') .. ':\\d*:\\d*') > -1 then
    local matchlist = vim.fn.matchlist(line, vim.fn.escape(path, '/') .. ':\\(\\d*\\):\\(\\d*\\)')
    row = matchlist[2] or 1
    col = matchlist[3] or 1
  end

  local buffers = vim.tbl_filter(function(entry)
    return entry.name:match(vim.pesc(path) .. '$') and vim.bo[entry.bufnr].buftype == ''
  end, vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }))

  local bufnr = -1
  local bufname = ''

  if #buffers == 0 then
    if vim.fn.filereadable(path) == 1 then
      vim.cmd('edit ' .. path)
      bufnr = vim.fn.bufnr('')
      bufname = vim.fn.bufname(bufnr)
    else
      return print('Unable to locate file/buffer for file ' .. path)
    end
  else
    bufnr = buffers[1].bufnr
    bufname = buffers[1].name
  end

  local winnr = vim.fn.bufwinnr(bufnr)
  if winnr < 0 then
    vim.cmd('vsplit ' .. bufname)
  else
    vim.cmd(winnr .. 'wincmd w')
  end
  vim.fn.cursor({ row, col })
end

local function open_file_or_create_new()
  local path = vim.fn.expand('<cfile>')
  if not path or path == '' then
    return false
  end

  if vim.bo.buftype == 'terminal' then
    return open_file_on_line_and_column()
  end

  if pcall(vim.cmd, 'norm!gf') then
    return true
  end

  vim.api.nvim_out_write('New file.\n')
  local new_path = vim.fn.fnamemodify(vim.fn.expand('%:p:h') .. '/' .. path, ':p')
  local ext = vim.fn.fnamemodify(new_path, ':e')

  if ext and ext ~= '' then
    return vim.cmd('edit ' .. new_path)
  end

  local suffixes = vim.fn.split(vim.bo.suffixesadd, ',')

  for _, suffix in ipairs(suffixes) do
    if vim.fn.filereadable(new_path .. suffix) then
      return vim.cmd('edit ' .. new_path .. suffix)
    end
  end

  return vim.cmd('edit ' .. new_path .. suffixes[1])
end

vim.keymap.set('n', 'gF', open_file_or_create_new)
vim.keymap.set('n', '<Leader>q', function()
  return close_buffer()
end)
vim.keymap.set('n', '<Leader>Q', function()
  return close_buffer(true)
end)

function mappings.paste_to_json_buffer()
  vim.cmd.vsplit()
  vim.cmd.enew()
  vim.bo.filetype = 'json'
  vim.cmd.norm({ '"+p', bang = true })
  vim.cmd.norm({ 'VGgq', bang = true })
end

local terminal_bufnr = 0
function mappings.toggle_terminal(close)
  if close then
    terminal_bufnr = 0
    return
  end
  if terminal_bufnr <= 0 then
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = '*',
      command = 'startinsert',
      once = true,
    })
    vim.cmd([[sp | term]])
    vim.cmd([[setlocal bufhidden=hide]])
    vim.api.nvim_create_autocmd('BufDelete', {
      pattern = '<buffer>',
      callback = function()
        mappings.toggle_terminal(true)
      end,
    })
    terminal_bufnr = vim.api.nvim_get_current_buf()
    return
  end

  local win = vim.fn.bufwinnr(terminal_bufnr)

  if win > -1 then
    vim.cmd(win .. 'close')
    return
  end

  vim.cmd('sp | b' .. terminal_bufnr .. ' | startinsert')
end

vim.api.nvim_create_user_command('Json', mappings.paste_to_json_buffer, { force = true })

local mapping_group = vim.api.nvim_create_augroup('vimrc_terminal_mappings', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    -- Focus first file:line:col pattern in the terminal output
    vim.keymap.set('n', 'F', [[:call search('\f\+:\d\+:\d\+')<CR>]], { buffer = true, silent = true })
    vim.bo.bufhidden = 'wipe'
  end,
  group = mapping_group,
})

vim.api.nvim_create_user_command('Cfilter', function(opts)
  vim.cmd.packadd('cfilter')
  vim.cmd.Cfilter({ args = opts.fargs, bang = opts.bang })
end, { force = true, bang = true, nargs = '*' })
