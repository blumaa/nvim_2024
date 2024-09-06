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
        function(server_name) -- default handler (optional)
          -- print('setting up ' .. server_name)
          if server_name == "tsserver" then
						server_name = "ts_ls"
					end

          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["tsserver"] = function()
          require("lspconfig").ts_ls.setup({
            capabilities = capabilities,
            -- root_dir = vim.loop.cwd,
            init_options = {
              plugins = {
                {
                  name = "typescript-lit-html-plugin",
                  -- location = vim.env.NODE_LIB,
                  location = "/Users/a.blum/.asdf/installs/nodejs/20.6.1/lib/node_modules/typescript-lit-html-plugin",
                },
                {
                  name = "ts-lit-plugin",
                  -- location = vim.env.NODE_LIB,
                  location = "/Users/a.blum/.asdf/installs/nodejs/20.6.1/lib/node_modules/ts-lit-plugin",
                },
              },
            },
          })
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
