return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", opts = {} },
    { "williamboman/mason-lspconfig.nvim", opts = {
        ensure_installed = {
          "lua_ls",
          "jsonls",
          "cssls",
          "html",
          "yamlls",
          "dockerls",
          "eslint",
          "stylelint_lsp",
          "vuels",
          "vtsls"
        },
      }
    },
    "j-hui/fidget.nvim",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- Function to find dynamic plugin paths
    local function find_node_module_path(plugin_name)
      local paths = {
        vim.fn.expand("~/.asdf/installs/nodejs/*/lib/node_modules/" .. plugin_name),
        vim.fn.expand("~/.nvm/versions/node/*/lib/node_modules/" .. plugin_name),
        vim.fn.expand("/usr/local/lib/node_modules/" .. plugin_name),
        vim.fn.expand("/opt/homebrew/lib/node_modules/" .. plugin_name),
      }

      for _, path in ipairs(paths) do
        local expanded = vim.fn.glob(path)
        if expanded ~= "" and vim.fn.isdirectory(expanded) == 1 then
          return expanded
        end
      end
      return nil
    end

    -- Configure lua_ls with vim.lsp.config (new API)
    vim.lsp.config('lua_ls', {
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

    -- Configure ts_ls with dynamic plugin detection
    local plugins = {}

    local lit_html_path = find_node_module_path("typescript-lit-html-plugin")
    if lit_html_path then
      table.insert(plugins, {
        name = "typescript-lit-html-plugin",
        location = lit_html_path,
      })
    end

    local ts_lit_path = find_node_module_path("ts-lit-plugin")
    if ts_lit_path then
      table.insert(plugins, {
        name = "ts-lit-plugin",
        location = ts_lit_path,
      })
    end

    vim.lsp.config('vtsls', {
      capabilities = capabilities,
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = plugins,
          },
        },
      },
    })

    -- Configure other LSP servers with default settings
    local default_servers = { "jsonls", "cssls", "html", "yamlls", "dockerls", "eslint", "stylelint_lsp", "vuels" }
    for _, server in ipairs(default_servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    require("fidget").setup({})

    vim.api.nvim_set_hl(0, "VioletBorder", { fg = "#FFFFFF", bold = true })
  end
}
