return {
    'tpope/vim-fugitive',
    
    config = function ()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local tk_Fugitive = vim.api.nvim_create_augroup("tk_Fugitive", {})
        
        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = tk_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end
            end,
        })
        vim.keymap.set("n","gu","<cmd>diffget //2<CR>")
        vim.keymap.set("n","gh","<cmd>diffget //3<CR>")
        vim.keymap.set("n","<leader>gc","<cmd>G commit -v -q<CR>")
        vim.keymap.set("n","<leader>ga","<cmd>G commit --amend<CR>")
        vim.keymap.set("n","<leader>gt","<cmd>G commit -v -q %<CR>")
        vim.keymap.set("n","<leader>gd","<cmd>Gdiff<CR>")
        vim.keymap.set("n","<leader>ge","<cmd>Gedit<CR>")
        vim.keymap.set("n","<leader>gr","<cmd>Gread<CR>")
        vim.keymap.set("n","<leader>gw","<cmd>Gwrite<CR><CR>")
        vim.keymap.set("n","<leader>gl","<cmd>G log<CR>")
        vim.keymap.set("n","<leader>gp","<cmd>G grep<Space><CR>")
        vim.keymap.set("n","<leader>gm","<cmd>G move<Space><CR>")
        vim.keymap.set("n","<leader>gb","<cmd>G branch<Space><CR>")
        vim.keymap.set("n","<leader>go","<cmd>G checkout<Space><CR>")
        vim.keymap.set("n","<leader>gps","<cmd>Dispatch! git push<CR>")
        vim.keymap.set("n","<leader>gpl","<cmd>Dispatch! git pull<CR>")
    end
}
