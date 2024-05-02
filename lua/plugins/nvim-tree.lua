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
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
  end,
}
