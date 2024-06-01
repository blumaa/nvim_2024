return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
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
          "node_modules",
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
          hidden = true
        }
      }
    }
  end
}
