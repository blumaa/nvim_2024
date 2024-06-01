return {

  {
    "rain",
    dir = "plugins/rain/rain",
    config = function()
      require("rain/rain").setup({
        character = ".",
        speed = 20,
        color = "lightblue",
        blend = 100
      })

      vim.api.nvim_set_keymap('n', '<leader>rn', ':RainOn<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>ro', ':RainOff<CR>', { noremap = true, silent = true })
    end
  },

  {
    "blumaa/ohne-accidents",
    event = "UIEnter",
    keys = {
      {
        "<leader>oh",
        ":OhneAccidents<CR>",
        desc = "Time since last config change",
      },
    },
    opts = {
      api = "echo",
      multiLine = true,
      welcomeOnStartup = false,
      -- useLastCommit = true,
    },
    -- config = function()
    --   require("ohne-accidents").setup({ welcomeOnStartup = false })
    --   vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents<CR>', { noremap = true, silent = true })
    -- end
  },

  -- {
  --   "blumaa/ohne-accidents.nvim",
  --   branch = "chore/add-option-to-use-notify-api-instead-of-echo",
  --   event = "UIEnter",
  --   keys = {
  --     {
  --       "<leader>oh",
  --       ":OhneAccidents<CR>",
  --       desc = "Time since last config change",
  --     },
  --   },
  --   opts = {
  --     api = "echo",
  --     multiLine = true,
  --     welcomeOnStartup = false,
  --     -- useLastCommit = true,
  --   },
  -- },
  -- Local development of ohne-accidents
  -- {
  --   "ohne-accidents",
  --   dir = "plugins/ohne-accidents/ohne-accidents",
  --   config = function()
  --     require("ohne-accidents/ohne-accidents").setup({ welcomeOnStartup = true })
  --
  --     vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents<CR>', { noremap = true, silent = true })
  --   end
  -- },

  {
    "blumaa/octopus.nvim",
    config = function()
      vim.keymap.set("n", "<leader>on", function()
        require("octopus").spawn()
      end, {})
      vim.keymap.set("n", "<leader>off", function()
        require("octopus").removeLastOctopus()
      end, {})
      vim.keymap.set("n", "<leader>ofa", function()
        require("octopus").removeAllOctopuses()
      end, {})
    end,
  },

}
