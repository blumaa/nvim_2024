return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      mappings = {
        close = 'q',
        reset = '<C-r>',
        complete = '<Tab>',
        submit_prompt = '<CR>',
        accept_diff = '<C-y>',
        show_diff = 'gd',
        show_system_prompt = 'gp',
        show_user_selection = 'gs',
      },

      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
