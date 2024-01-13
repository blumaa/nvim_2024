local set = vim.opt

set.number = true
set.backspace = '2'
set.showcmd = true
set.laststatus = 2
set.autowrite = true
set.autoread = true
set.cursorline = true
set.cursorlineopt = 'number'
set.relativenumber = true
set.wrap = false
set.ignorecase = true
set.smartcase = true
set.termguicolors = true
set.autoindent = true
set.smartindent = true
set.softtabstop = 4
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true
set.shiftround = true
set.formatoptions:remove({ 'c', 'r', 'o' })
set.mousemoveevent = true
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true


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
