return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle Vsplit" },
    },
    opts = {
      debug = true,         -- Enable debugging
      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.25,        -- fractional width of parent, or absolute width in columns when > 1
        height = 0.25,       -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
        border = 'single',  -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil,          -- row position of the window, default is centered
        col = nil,          -- column position of the window, default is centered
        title = 'Copilot Chat', -- title of chat window
        footer = nil,       -- footer of chat window
        zindex = 1,         -- determines if window is on top or below other floating windows
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal = '<C-r>',
          insert = '<C-r>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        show_diff = {
          normal = 'gd'
        },
        show_system_prompt = {
          normal = 'gp'
        },
        show_user_selection = {
          normal = 'gs'
        },
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
    event = 'VeryLazy',
  },
}
