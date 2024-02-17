return {
    "lewis6991/gitsigns.nvim",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function() 
        require('gitsigns').setup {
            signs = { 
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            current_line_blame = false,
            -- Highlights just the number part of the number column
            numhl = true,

            -- Highlights the _whole_ line.
            --    Instead, use gitsigns.toggle_linehl()
            linehl = false,

            -- Highlights just the part of the line that has changed
            --    Instead, use gitsigns.toggle_word_diff()
            word_diff = false,

            current_line_blame_opts = {
                delay = 2000,
                virt_text_pos = "eol",
            },
        }
    end
}
