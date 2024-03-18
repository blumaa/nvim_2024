return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',   -- LSP source for nvim-cmp
    'hrsh7th/cmp-path',     -- LSP source for nvim-cmp
    'hrsh7th/cmp-cmdline',  -- LSP source for nvim-cmp
    'hrsh7th/nvim-cmp',     -- Autocompletion plugin
  },
  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )
    require('mason').setup({})
    require("mason-lspconfig").setup {
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "jsonls",
        "tsserver",
        "cssls",
        "html",
        "yamlls",
        "dockerls",
        "eslint",
        "stylelint_lsp"
      },
      handlers = {
        function(server_name)  -- default handler (optional)
          -- print('setting up ' .. server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }
                }
              }
            }
          }
        end,
      }
    }
    require("fidget").setup({})
  end
}
