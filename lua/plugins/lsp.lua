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
        "cssls",
        "html",
        "yamlls",
        "dockerls",
        "stylelint_lsp",
        "vuels",
        "ts_ls"
      },
      handlers = {
        function(server_name) -- default handler (optional)
          -- Skip servers that have custom handlers below
          if server_name == "ts_ls" or server_name == "lua_ls" or server_name == "eslint" then
            return
          end
          
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
          }
        end,
        ["ts_ls"] = function()
          require("lspconfig").ts_ls.setup({
            capabilities = capabilities,
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              })
            end,
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
        -- ["stylelint_lsp"] = function()
        --   require("lspconfig").stylelint_lsp.setup {
        --     capabilities = capabilities,
        --     filetypes = { "css", "scss", "less" },
        --     settings = {
        --       stylelintplus = {
        --         autoFixOnSave = false,
        --         autoFixOnFormat = false,
        --         configFile = ".stylelintrc.json" -- Adjust this path if needed
        --       }
        --     }
        --   }
        -- end,
        -- ["prettier"] = function()
        --   require("lspconfig").prettierd.setup {
        --     capabilities = capabilities,
        --     filetypes = { "css", "scss", "less", "javascript", "typescript", "json" },
        --   }
        -- end,
        ["eslint"] = function()
          -- Only setup ESLint if config file exists
          local eslint_config_files = {
            ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", 
            ".eslintrc.json", "eslint.config.js", "eslint.config.mjs"
          }
          
          local has_config = false
          for _, config_file in ipairs(eslint_config_files) do
            if vim.fn.filereadable(config_file) == 1 then
              has_config = true
              break
            end
          end
          
          if has_config then
            require("lspconfig").eslint.setup({
              capabilities = capabilities,
            })
          end
        end,
      }
    }
    require("fidget").setup({})
  end
}
