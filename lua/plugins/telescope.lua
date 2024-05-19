return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  -- or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
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

    require("telescope").load_extension('harpoon')
    require('telescope').setup {
      defaults = {
        prompt_prefix = "󰼛 ",
        selection_caret = "󱞩 ",
        -- sorting_strategy = "ascending",
        -- layout_config = {
        --   horizontal = {
        --     prompt_position = "top",
        --     preview_width = 0.5,
        --     results_width = 0.5,
        --   },
        -- },
        file_ignore_patterns = {
          -- "node_modules",
          -- "yarn.lock",
          -- ".git",
        },
        path_display = { "truncate" },
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
