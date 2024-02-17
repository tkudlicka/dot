return {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { noremap = true, silent = true })
    end,
}
