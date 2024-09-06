return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')

    -- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fr", ":Telescope resume<CR>")
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word }
      -- builtin.grep_string({ search = vim.fn.input("Grep > ") }
      );
    end)
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word }
      );
    end)

    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({find_command = {'rg', '--files', '--hidden', '--ignore', '-g', '!.git'}})
    end)

     -- {';?', builtin.oldfiles, desc = desc('Find recently opened files')},
     --    {';;', builtin.buffers, desc = desc('Find opened buffers in current neovim instance')},
     --    {';/', builtin.current_buffer_fuzzy_find, desc = desc('Fuzzily search in current buffer')},
     --    {'gr', builtin.lsp_references, desc = desc('Goto References')},
     --    {';sl', builtin.live_grep, desc = desc('Search by live grep')},
     --    {';gf', builtin.git_files, desc = desc('Search Git Files')},
     --    {';sk', builtin.keymaps, desc = desc('Keymaps')},
     --    {';sd', builtin.diagnostics, desc = desc('Search Diagnostics')},
     --    {';sh', builtin.help_tags, desc = desc('Search Help')},
     --    {';sc', builtin.colorscheme, desc = desc('Search Colorscheme')},
     --    {';ss', builtin.search_history, desc = desc('Get list of searches')},
     --    {'<leader>ds', builtin.lsp_document_symbols, desc = desc('Document Symbols')},
     --    {'<leader>ws', builtin.lsp_dynamic_workspace_symbols, desc = desc('Workspace Symbols')},
     --    {'sf', function() telescope.extensions.file_browser.file_browser({path = '%:p:h', hidden = true, respect_gitignore = false}) end, desc = desc('Search Files')},
     --    {';f', function() builtin.find_files({no_ignore = true, hidden = true}) end, desc = desc('Find files not respecting gitignore')},
     --    {';sf', function() builtin.find_files({find_command = {'rg', '--files', '--hidden', '--ignore', '-g', '!.git'}}) end, desc = desc('Search files respecting gitignore')},
     --    {';cd', function() builtin.find_files({cwd = require('telescope.utils').buffer_dir()}) end, desc = desc('Search in Current buffer Directory')},
     --    {';sg', function() builtin.grep_string({search = vim.fn.input('Grep > ')}) end, desc = desc('Search by grep')},
     --    {';sw', function() builtin.grep_string({search = vim.fn.expand('<cword>')}) end, desc = desc('Search word under cursor')},
     --    {';sW', function() builtin.grep_string({search = vim.fn.expand('<cWORD>')}) end, desc = desc('Search WORD under cursor')},
     --    {';se', function() builtin.diagnostics({bufnr = 0}) end, desc = desc('Get file diagnostics')},


    local actions = require('telescope.actions')

    -- require('telescope.pickers.layout_strategies').horizontal_merged = function(picker, max_columns, max_lines, layout_config)
    --   local layout = require('telescope.pickers.layout_strategies').horizontal(picker, max_columns, max_lines,
    --     layout_config)
    --
    --   layout.prompt.title = ''
    --   layout.prompt.borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    --
    --   layout.results.title = ''
    --   layout.results.borderchars = { '─', '│', '─', '│', '├', '┤', '┘', '└' }
    --   layout.results.line = layout.results.line - 1
    --   layout.results.height = layout.results.height + 1
    --
    --   layout.preview.title = ''
    --   layout.preview.borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    --
    --   return layout
    -- end
    --
    require("telescope").load_extension('harpoon')
    require('telescope').setup {
      defaults = {
        -- layout_strategy = 'horizontal_merged',
        prompt_prefix = "󰼛 ",
        selection_caret = "󱞩 ",
        -- sorting_strategy = "ascending",
        -- layout_config = {
          -- horizontal = {
            -- prompt_position = "top",
            -- preview_width = 0.5,
            -- results_width = 0.5,
          -- },
        -- },
        file_ignore_patterns = {
          -- "node_modules",
          -- "yarn.lock",
          -- ".git",
        },
        path_display = {
          "absolute",
          shorten = {
            len = 5,
            exclude = { -1, -2 }
          }
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
          },
          n = {
            ["q"] = require("telescope.actions").close,
            ["<esc>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = {"rg", "--files", "--sortr=modified"}
        }
      }
    }
  end
}
