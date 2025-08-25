return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "j-hui/fidget.nvim",
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
    'hrsh7th/cmp-buffer',   -- LSP source for nvim-cmp
    'hrsh7th/cmp-path',     -- LSP source for nvim-cmp
    'hrsh7th/cmp-cmdline',  -- LSP source for nvim-cmp
    'hrsh7th/nvim-cmp',     -- Autocompletion plugin
  },
  config = function()
    require("mason").setup({})

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require("lspconfig")
    
    -- Set up the essential LSP keybindings that aren't default
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover info' })
    -- grn, gra, grr, gri are already mapped by default

    -- Setup servers with custom configurations
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
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
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    })

    -- Setup vtsls for React files only
    lspconfig.vtsls.setup({
      capabilities = capabilities,
      cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vtsls"), "--stdio" },
      filetypes = { 'javascriptreact', 'typescriptreact' },
      settings = {
        vtsls = {
          enableMoveToFileCodeAction = true,
          autoUseWorkspaceTsdk = true,
        },
        typescript = {
          preferences = {
            includePackageJsonAutoImports = "on",
          },
          tsdk = "./node_modules/typescript/lib",
        },
      },
    })
    
    -- Use ts_ls for TypeScript/JavaScript and Vue files with Vue plugin
    local function get_node_modules_path()
      local node_path = vim.fn.system("node -e 'console.log(process.execPath)'"):gsub("%s+", "")
      return node_path:gsub("/bin/node", "/lib/node_modules")
    end
    
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      filetypes = { 'typescript', 'javascript', 'vue' },
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = get_node_modules_path() .. "/@vue/typescript-plugin",
            languages = { "vue" },
          },
          {
            name = "typescript-lit-html-plugin",
            location = get_node_modules_path() .. "/typescript-lit-html-plugin",
          },
          {
            name = "ts-lit-plugin",
            location = get_node_modules_path() .. "/ts-lit-plugin",
          },
        },
      },
    })

    -- Setup other servers manually
    local servers = { "eslint", "cssls", "html", "jsonls", "yamlls", "dockerls", "stylelint_lsp" }
    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        capabilities = capabilities,
      })
    end

    require("fidget").setup({})
  end
}
