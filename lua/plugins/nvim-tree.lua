return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()

    require('nvim-tree').setup({
      view = {
        adaptive_size = true,
      },
      -- filters = {
      --   dotfiles = false,
      --   custom = {
      --     "^.git$",
      --     "^.sl$",
      --     "^.DS_Store",
      --     "^target$",
      --     "^node_modules$",
      --   },
      -- },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })

  end,
}
