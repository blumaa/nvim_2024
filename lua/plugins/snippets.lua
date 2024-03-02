return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "benfowler/telescope-luasnip.nvim",
    },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
        { "vscode", "snipmate", "lua" }
      )
      require("luasnip").filetype_extend("typescript", { "tsdoc" })
      require("luasnip").filetype_extend("javascript", { "jsdoc" })
      require("luasnip").filetype_extend("lua", { "luadoc" })
      require('luasnip').filetype_extend("javascript", { "javascriptreact" })
      require('luasnip').filetype_extend("typescript", { "typescriptreact" })
      require('luasnip').filetype_extend("javascript", { "html" })
      require("luasnip").filetype_extend("ruby", { "rdoc" })
    end,

  }
}
