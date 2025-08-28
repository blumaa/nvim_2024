vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = 'plugins',
  change_detection = { notify = false },
  ui = {
      border = 'rounded',
      backdrop = 100,
    },
})


require("remap")
require("settings")

local augroup = vim.api.nvim_create_augroup
local MyGroup = augroup('MyGroup', {})
local autocmd = vim.api.nvim_create_autocmd
--
--
-- autocmd({"BufWritePre"}, {
--     group = MyGroup,
--     pattern = "*",
--     command = [[%s/\s\+$//e]],
-- })

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
          vim.api.nvim_win_set_option(winnr, 'winblend', 0)
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
