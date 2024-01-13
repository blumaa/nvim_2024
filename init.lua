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

vim.g.mapleader = " "
vim.g.maplocalloeader = " "

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
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.keymap.set("i", "jk", "<ESC>")
-- jump to test and back
vim.keymap.set("n", "<leader>gt", ":A<cr>")

-- move line up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- bring lower line up to end of current line
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

-- formatting
vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>pp", ":Prettier<CR>")

-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>tr", ":Telescope lsp_references<CR>")

-- search and replace current word
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- easily save and exit windows
vim.keymap.set("n", "<RIGHT>", ":q<CR>")
vim.keymap.set("n", "fd", ":q<CR>")
vim.keymap.set("n", "<DOWN>", ":w<CR>")

-- qucik exit/escape
vim.keymap.set("i", "jk", "<ESC>")

-- Resize Panes
vim.keymap.set("n", "<leader>9", ":horizontal resize +4<CR>")
vim.keymap.set("n", "<leader>0", ":horizontal resize -4<CR>")
vim.keymap.set("n", "<leader>1", ":vertical resize +4<CR>")
vim.keymap.set("n", "<leader>2", ":vertical resize -4<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Nvimtree
vim.keymap.set("n", "<leader>e", ":Neotree<cr>")

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

vim.keymap.set('n', '<Leader>d', ':call v:lua.toggle_diagnostics()<CR>')
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>-", ":vsplit<cr>")
vim.keymap.set("n", "<leader>_", ":split<cr>")

-- vim-test shortcuts
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile -strategy=neovim<CR>', { noremap = true, silent = true })

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

require("lazy").setup({
  spec = 'plugins',
  change_detection = { notify = false }
})
