return {

  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup()
    end
  },

  -- "tpope/vim-sleuth",

  {
    "jdrupal-dev/css-vars.nvim",
    config = function()
      require("css-vars").setup()
    end,
  },

  -- {
  --   'brenoprata10/nvim-highlight-colors',
  --   config = function()
  --     require('nvim-highlight-colors').setup({
  --       ---Render style
  --       ---@usage 'background'|'foreground'|'virtual'
  --       render = 'virtual',
  --
  --       ---Set virtual symbol (requires render to be set to 'virtual')
  --       virtual_symbol = '■',
  --
  --       ---Highlight named colors, e.g. 'green'
  --       enable_named_colors = true,
  --
  --       ---Highlight tailwind colors, e.g. 'bg-blue-500'
  --       enable_tailwind = false,
  --
  --       ---Set custom colors
  --       ---Label must be properly escaped with '%' to adhere to `string.gmatch`
  --       --- :help string.gmatch
  --       custom_colors = {
  --         { label = '%-%-theme%-primary%-color', color = '#0f1219' },
  --         { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
  --       }
  --     })
  --   end
  -- },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true,
    event = 'VeryLazy',
  },

  -- {
  --   'eandrju/cellular-automaton.nvim',
  --   config = function()
  --     vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
  --   end
  -- },

  -- {
  --   "crnvl96/lazydocker.nvim",
  --   event = "VeryLazy",
  --   opts = {}, -- automatically calls `require("lazydocker").setup()`
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   }
  -- },

  "mbbill/undotree",

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
        languages = {
          typescript = '// %s',
        },
      }
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

}
