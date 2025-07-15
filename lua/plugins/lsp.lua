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
    
    -- Setup LSP servers directly without automatic_enable
    local lspconfig = require('lspconfig')
    
    -- Setup servers manually
    local servers = {
      "lua_ls",
      "jsonls", 
      "cssls",
      "html",
      "yamlls",
      "dockerls",
      "eslint",
      "stylelint_lsp",
      "vue-language-server"
    }
    
    for _, server in ipairs(servers) do
      if server == "lua_ls" then
        -- Custom lua_ls setup (keeping your existing config)
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
                version = 'LuaJIT'
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                }
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
      elseif server == "ts_ls" then
        -- TypeScript server
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
          init_options = {
            plugins = {
              {
                name = "typescript-lit-html-plugin",
                location = "/Users/a.blum/.asdf/installs/nodejs/20.6.1/lib/node_modules/typescript-lit-html-plugin",
              },
              {
                name = "ts-lit-plugin",
                location = "/Users/a.blum/.asdf/installs/nodejs/20.6.1/lib/node_modules/ts-lit-plugin",
              },
            },
          },
        })
      elseif server == "vue-language-server" then
        -- Vue language server (Volar) in takeover mode
        lspconfig.volar.setup({
          capabilities = capabilities,
          filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue'},
          init_options = {
            vue = {
              hybridMode = false,
            },
          },
        })
      else
        -- Default setup for other servers
        lspconfig[server].setup {
          capabilities = capabilities,
        }
      end
    end
    
    -- ts_ls setup is handled above in the loop now
    
    require("fidget").setup({})
  end
}
