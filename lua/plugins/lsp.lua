return {
  { "folke/neodev.nvim", opts = {} },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require('neodev').setup({})

      local lsp_config = require('lspconfig')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lsp_config.lua_ls.setup({
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          vim.api.nvim_set_keymap('n', '<leader>Hw', ':help <C-R><C-W><CR>',
            { noremap = true, buffer = bufnr, silent = true, desc = "Help under cursor" })
        end,
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            completion = {
              callSnippet = "Replace"
            }
          }
        }
      })

      lsp_config.eslint.setup({
        capabilities = capabilities,
        root_dir = lsp_config.util.root_pattern("package.json", "package-lock.json"),
        filetypes = {
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
        },
        single_file_support = true
      })

      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lsp_config.cssls.setup {
        capabilities = capabilities,
        }


      lsp_config.tsserver.setup({
        capabilities = capabilities,
      })

      local check_eslint_config = function(client)
        if client.name ~= "eslint" and client.name ~= "tsserver" then
          return false
        end
        return true
      end

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      -- vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
      --    vim.keymap.set('n', '<leader>ws', ':Telescope lsp_dynamic_workspace_symbols <CR>',
      --      { desc = "[W]orkspace [S]ymbols" })
      --    vim.keymap.set('n', '<leader>ds', ':Telescope lsp_document_symbols <CR>', { desc = "[D]ocument [S]ymbols" })
      --    vim.keymap.set('n', '<leader>od', ':lua vim.diagnostic.open_float()<CR>', { desc = "[O]pen [D]iagnostic" })
      --    vim.keymap.set('n', '<leader>d]', ':lua vim.diagnostic.goto_next()<CR>', { desc = "Next ] [D]iagnostic" })
      --    vim.keymap.set('n', '<leader>d[', ':lua vim.diagnostic.goto_prev()<CR>', { desc = "Prev [ [D]iagnostic" })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local ts_builtin = require('telescope.builtin')

          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          -- keymap go to definition
          vim.keymap.set('n', 'gtd', vim.lsp.buf.definition, opts)


          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', 'gd', ts_builtin.lsp_definitions, opts)
          vim.keymap.set('n', 'gr', ts_builtin.lsp_references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          print("[" .. client.name .. "] ")

          -- -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          -- -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          -- -- vim.keymap.set('n', '<leader>wl', function()
          -- --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          -- -- end, opts)

          -- Formatting

          if check_eslint_config(client) then
            vim.keymap.set("n", "<leader>=", ":EslintFixAll<CR>", opts)
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --   buffer = ev.buf,
            --   command = ":EslintFixAll",
            -- })
          else
            vim.keymap.set('n', '<leader>=', vim.lsp.buf.format, opts)
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --   buffer = ev.buf,
            --   command = "lua vim.lsp.buf.format()"
            -- })
          end
        end,
      }
      -- vim.g.rustaceanvim = {
      --   server = {
      --     on_attach = on_attach
      --   }
      -- }


      vim.api.nvim_create_autocmd('LspAttach', on_attach)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = { 'lua_ls', 'eslint', 'cssls' }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    config = function()
      local mason = require('mason')

      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  }
}
