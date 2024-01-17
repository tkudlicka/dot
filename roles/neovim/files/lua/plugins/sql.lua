return {
  {
      "hexdigest/go-enhanced-treesitter.nvim",
      build = ":TSInstall go sql",
      ft = "go",
  },
  {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
      "DB",
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
  },
  init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
  end,
  }
}
