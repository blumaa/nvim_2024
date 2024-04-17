return {
  'b0o/incline.nvim',
  config = function()
    local helpers = require 'incline.helpers'
    local devicons = require 'nvim-web-devicons'
    require('incline').setup {
      window = {
        placement = {
          vertical = "bottom",
          horizontal = "right",
        },
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      render = function(props)
        local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':p')
        local parent_folder_and_file = vim.fn.fnamemodify(filepath, ':h:t') .. '/' .. vim.fn.fnamemodify(filepath, ':t')
        if parent_folder_and_file == '' then
          parent_folder_and_file = '[No Name]'
        end
        local ft_icon, ft_color = devicons.get_icon_color(parent_folder_and_file)
        local modified = vim.bo[props.buf].modified
        return {
          ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
          ' ',
          { parent_folder_and_file .. ' ', gui = modified and 'bold,italic' or 'bold' },
          ' ',
          guibg = '#44406e',
        }
      end,
    }
  end,
  -- Optional: Lazy load Incline
  event = 'VeryLazy',
}
