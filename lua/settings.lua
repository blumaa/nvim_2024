-- ensure that the project is using the local .editorconfig file
vim.g.editorconfig = true

-- Define a function to append a space to the end of the file
function AppendSpace()
  local line_count = vim.fn.line('$')
  if line_count == 1 or vim.fn.getline(line_count) ~= '' then
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { ' ' })
  end
end

-- Create a keymap to call the function when pressing <leader>sp
vim.api.nvim_set_keymap('n', '<leader>sp', ':lua AppendSpace()<CR>', { noremap = true, silent = true })

vim.g.termguicolors = true
-- vim.g.nofixendofline = true
local set = vim.opt

set.number = true
set.backspace = '2'
set.showcmd = true
set.laststatus = 0
set.autowrite = true
set.autoread = true
set.cursorcolumn = true
set.cursorline = true
set.cursorlineopt = 'screenline'
set.relativenumber = true
set.ignorecase = true
set.smartcase = true
set.termguicolors = true
set.autoindent = true
set.smartindent = true
set.scrolloff = 10
set.softtabstop = 4
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.shiftround = true
set.formatoptions:remove({ 'c', 'r', 'o' })
set.mousemoveevent = true
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true
set.wrap = false


-- LSP toggle diagnostics virtual_text
vim.g.diagnostics_visible = true

function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.config({ virtual_text = true })
  end
end

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.loaded_perl_provider = 0
