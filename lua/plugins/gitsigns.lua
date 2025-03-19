return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup {
      signs                        = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      auto_attach                  = true,
      attach_to_untracked          = false,
      current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,   -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      on_attach                    = function(bufnr)
        local gs = package.loaded.gitsigns

        -- XXX

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        local inline_diff_enabled = false
        local ns_id = vim.api.nvim_create_namespace('gitsigns_inline_diff')


        local function show_inline_diff()
          local current_line = vim.fn.line('.')
          local diff = gs.get_hunks()

          print("Current line: " .. current_line)
          print("Diff: " .. vim.inspect(diff))

          vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

          if not diff or #diff == 0 then
            print("No diff information available")
            vim.api.nvim_buf_set_virtual_text(0, ns_id, current_line - 1, { { "No changes", "Comment" } }, {})
            return
          end

          for i, hunk in ipairs(diff) do
            print("Processing hunk " .. i .. ": " .. vim.inspect(hunk))

            if not hunk.start or not hunk.count then
              print("Invalid hunk data for hunk " .. i)
              goto continue
            end

            if current_line >= hunk.start and current_line <= (hunk.start + hunk.count - 1) then
              local removed_count = (hunk.removed and hunk.removed.count) or 0
              local added_count = (hunk.added and hunk.added.count) or 0
              local diff_text = string.format("Diff: -%d +%d", removed_count, added_count)

              if hunk.type == "add" then
                diff_text = diff_text .. " (Added)"
              elseif hunk.type == "delete" then
                diff_text = diff_text .. " (Deleted)"
              elseif hunk.type == "change" then
                diff_text = diff_text .. " (Changed)"
              end

              print("Setting virtual text: " .. diff_text)
              vim.api.nvim_buf_set_virtual_text(0, ns_id, current_line - 1, { { diff_text, "GitSignsChange" } }, {})
              return
            end

            ::continue::
          end

          print("No matching hunk found")
          vim.api.nvim_buf_set_virtual_text(0, ns_id, current_line - 1, { { "No changes", "Comment" } }, {})
        end

        local function toggle_inline_diff()
          inline_diff_enabled = not inline_diff_enabled
          if inline_diff_enabled then
            show_inline_diff()
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = bufnr,
              callback = show_inline_diff
            })
            print("Inline diff enabled")
          else
            vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
            vim.api.nvim_clear_autocmds({ buffer = bufnr, event = "CursorMoved" })
            print("Inline diff disabled")
          end
        end

        -- XXX


        -- Navigation
        map('n', ']d', function()
          if vim.wo.diff then return ']d' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[d', function()
          if vim.wo.diff then return '[d' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        -- map('n', '<leader>hs', gs.stage_hunk)
        -- map('n', '<leader>hr', gs.reset_hunk)
        -- map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        -- map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        -- map('n', '<leader>hS', gs.stage_buffer)
        -- map('n', '<leader>hu', gs.undo_stage_hunk)
        -- map('n', '<leader>hR', gs.reset_buffer)
        -- map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>fb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        -- map('n', '<leader>fb', toggle_inline_diff, { desc = 'Toggle inline diff' })
        -- map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        -- map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }
  end,
}
