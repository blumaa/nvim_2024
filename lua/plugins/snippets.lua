return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      -- require("luasnip").filetype_extend("typescript", { "tsdoc" })
      -- require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require('luasnip').filetype_extend("javascript", { "javascriptreact" })
      require('luasnip').filetype_extend("typescript", { "typescriptreact" })
      require('luasnip').filetype_extend("javascript", { "html" })
      require("luasnip").filetype_extend("ruby", { "rdoc" })
    end
  }
}
