function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    lazy = false,
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
        -- require('rose-pine').setup({
        --     styles = {
        --         transparency = true
        --     }
        -- })
        vim.opt.termguicolors = true
        vim.cmd("colorscheme stormpetrel")
        -- ColorMyPencils()
    end
}
