return {
    "ThePrimeagen/git-worktree.nvim",
    config = function() 
        local telescope = require('telescope')
        vim.keymap.set("n", "<leader>gt", function()
            telescope.extensions.git_worktree.git_worktrees()
        end)
    end
}
