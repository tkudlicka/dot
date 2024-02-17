return {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        'rcarriga/nvim-notify',
    },
    config = function() 
        local telescope = require('telescope')
        telescope.load_extension('git_worktree')
        local Worktree = require("git-worktree")
        local Path = require("plenary.path")

        Worktree.setup({})

        vim.keymap.set("n", "<leader>gt", function()
            telescope.extensions.git_worktree.git_worktrees()
        end)

        vim.keymap.set("n", "<leader>gn", function()
            telescope.extensions.git_worktree.create_git_worktree()
        end)

        Worktree.on_tree_change(function(op, metadata)
            if op == Worktree.Operations.Create then
                local path = metadata.path
                if not Path:new(path):is_absolute() then
                    path = Path:new():absolute()
                    if path:sub(-#"/") == "/" then
                        path = string.sub(path, 1, string.len(path) - 1)
                    end
                end
                local worktree_path = path .. "/" .. metadata.path .. "/"
                
                os.execute("cd " .. worktree_path .. " && cp ../.env ./")
                -- Execute npm install as a silent job using vim.loop.spawn
                vim.loop.spawn("npm", {
                    args = {"install"},
                    cwd = worktree_path,
                    stdio = {nil, nil, nil}  -- Set stdio to nil for stdin, stdout, and stderr
                }, function(code)
                    if code == 0 then
                        vim.schedule(function()
                                require("notify")("Worktree " .. metadata.path .. " created and npm install ran", "info", {
                                    title = "Worktree",
                                    timeout = 5000
                                })
                        end)
                    else
                        print("Error executing npm install")
                    end
                end)
            elseif op == Worktree.Operations.Switch then
                print("Switched worktree at " .. metadata.path .. " on branch ")
            end
        end)
    end
}
