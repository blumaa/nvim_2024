return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = true
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

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  "mbbill/undotree",

  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --   end,
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   }
  -- },

  'MunifTanjim/prettier.nvim',

  -- {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   config = function()
  --     local null_ls = require("null-ls")
  --
  --     null_ls.setup({
  --       sources = {
  --         null_ls.builtins.formatting.stylua,
  --         null_ls.builtins.diagnostics.eslint,
  --         -- null_ls.builtins.completion.spell,
  --       },
  --     })
  --   end
  -- },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end
  },

  'JoosepAlviste/nvim-ts-context-commentstring',

  {
    "nvim-tree/nvim-web-devicons", lazy = true
  },

}
