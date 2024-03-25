return {

  {
    "blumaa/ohne-accidents",
    config = function()
      require("ohne-accidents").setup()
      vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents status<CR>', { noremap = true, silent = true })
    end
  },

  -- Local development of ohne-accidents
  -- {
  --   "ohne-accidents",
  --   dir = "plugins/ohne-accidents/ohne-accidents.nvim",
  --   config = function()
  --     require("ohne-accidents/ohne-accidents").setup()
  --
  --     vim.api.nvim_set_keymap('n', '<leader>oh', ':OhneAccidents status<CR>', {noremap = true, silent = true})
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
