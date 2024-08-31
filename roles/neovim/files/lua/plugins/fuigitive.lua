return {
    'tpope/vim-fugitive',

    config = function()
        vim.keymap.set("n", "<leader>gs", ':vert G<CR>', { silent = true, desc = 'Open fugitive' })
        local git_group = vim.api.nvim_create_augroup('custom_fugitive', { clear = true })
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'fugitive',
            callback = function()
                vim.keymap.set('n', '<Leader>', '=zt', { remap = true, silent = true, buffer = true })
                vim.keymap.set('n', '}', ']m=zt', { remap = true, silent = true, buffer = true })
                vim.keymap.set('n', '{', '[m=zt', { remap = true, silent = true, buffer = true })
            end,
            group = git_group,
        })
    end
}
