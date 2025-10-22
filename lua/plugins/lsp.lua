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
    'hrsh7th/cmp-nvim-lsp',  -- Needed for capabilities setup
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

    -- Configure ESLint conditionally (only when config exists)
    vim.lsp.config('eslint', {
      capabilities = capabilities,
      root_dir = function(fname)
        local util = require('lspconfig.util')
        return util.root_pattern(
          '.eslintrc',
          '.eslintrc.js',
          '.eslintrc.cjs',
          '.eslintrc.yaml',
          '.eslintrc.yml',
          '.eslintrc.json',
          'eslint.config.js',
          'eslint.config.mjs',
          'eslint.config.cjs'
        )(fname)
      end,
    })

    -- Configure other LSP servers with default settings
    local default_servers = { "jsonls", "cssls", "html", "yamlls", "dockerls", "stylelint_lsp", "vuels" }
    for _, server in ipairs(default_servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    require("fidget").setup({})

    vim.api.nvim_set_hl(0, "VioletBorder", { fg = "#FFFFFF", bold = true })

    -- LSP keybindings and custom hover handler
    local autocmd = vim.api.nvim_create_autocmd
    local MyGroup = vim.api.nvim_create_augroup('MyLspGroup', { clear = true })

    autocmd('LspAttach', {
      group = MyGroup,
      callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
        vim.keymap.set("n", "gd", function()
          vim.lsp.buf.definition({
            on_list = function(options)
              if #options.items == 1 then
                vim.cmd("edit " .. options.items[1].filename)
                vim.api.nvim_win_set_cursor(0, {options.items[1].lnum, options.items[1].col - 1})
              else
                vim.fn.setqflist({}, ' ', options)
                vim.api.nvim_command('cfirst')
              end
            end
          })
        end, opts)
        vim.keymap.set("n", "K", function()
          -- Get the client and use its offset encoding
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local encoding = clients[1] and clients[1].offset_encoding or 'utf-16'
          local params = vim.lsp.util.make_position_params(0, encoding)

          vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, config)
            if not (result and result.contents) then return end

            local contents = result.contents
            -- Convert string to table format if needed
            if type(contents) == "string" then
              contents = vim.split(contents, '\n', { plain = true })
            elseif contents.kind and contents.value then
              contents = vim.split(contents.value, '\n', { plain = true })
            end

            -- Clean up content and add left/right padding only
            local padded_contents = {}
            for i, line in ipairs(contents) do
              -- Skip leading/trailing empty lines but keep code block markers
              if not (line == "" and (i == 1 or i == #contents)) then
                table.insert(padded_contents, "  " .. line .. "  ")  -- left/right padding only
              end
            end

            local bufnr, winnr = vim.lsp.util.open_floating_preview(padded_contents, 'markdown', {
              border = {
                { "╭", "VioletBorder" },
                { "─", "VioletBorder" },
                { "╮", "VioletBorder" },
                { "│", "VioletBorder" },
                { "╯", "VioletBorder" },
                { "─", "VioletBorder" },
                { "╰", "VioletBorder" },
                { "│", "VioletBorder" },
              },
              focusable = true,
            })

            -- Remove top/bottom padding by adjusting window options
            if winnr and vim.api.nvim_win_is_valid(winnr) then
              vim.api.nvim_set_option_value('winblend', 0, { win = winnr })
            end
          end)
        end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end
    })
  end
}
