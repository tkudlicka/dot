return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
      { "ibhagwan/fzf-lua" }
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    config = function()
      local chat = require('CopilotChat')
      local actions = require('CopilotChat.actions')
      local integration = require('CopilotChat.integrations.fzflua')

      local function pick(pick_actions)
        return function()
          integration.pick(pick_actions(), {
            fzf_tmux_opts = {
              ['-d'] = '45%',
            },
          })
        end
      end

      chat.setup({
        question_header = '',
        answer_header = '',
        error_header = '',
        allow_insecure = true,
        mappings = {
          reset = {
            normal = '',
            insert = '',
          },
        },
        prompts = {
          Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
          },
          Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
          },
          Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
          },
          Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
          },
          Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
          },
          Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
          },
          CommitStaged = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
          },
        },
      })


      vim.keymap.set({ 'n', 'v' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ah', pick(actions.help_actions), { desc = 'AI Help Actions' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ap', pick(actions.prompt_actions), { desc = 'AI Prompt Actions' })
    end
  },
}
