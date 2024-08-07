-- Clear search with <esc>
-- vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
vim.keymap.set('n', '<leader>q', ':nohlsearch<CR>', { noremap = true, silent = true })

-- vim.keymap.set('n', '<leader>d', ':call v:lua.toggle_diagnostics()<CR>')
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>-", ":vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>_", ":split<cr>", { desc = "Horizontal Split" })

-- vim-test shortcuts
-- vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile -strategy=neovim<CR>', { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<ESC>")
-- jump to test and back
-- vim.keymap.set("n", "<leader>gt", ":A<cr>")

-- move line up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- bring lower line up to end of current line
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "vA", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "yA", "ggVGy", { desc = "Copy All" })


vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

-- formatting
vim.keymap.set("n", "<leader>=", ":EslintFixAll<CR>")
vim.keymap.set("n", "<leader>+", vim.lsp.buf.format)
-- vim.keymap.set("n", "<leader>pr", ":Prettier<CR>")

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

vim.keymap.set({ "n", "v", "x" }, "<S-Down>", "<cmd>resize -2<cr>", { desc = "Resize Split Down" })
vim.keymap.set({ "n", "v", "x" }, "<S-Up>", "<cmd>resize +2<cr>", { desc = "Resize Split Up" })
vim.keymap.set({ "n", "v", "x" }, "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Resize Split Left" })
vim.keymap.set({ "n", "v", "x" }, "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize Split Right" })

-- Resize Panes
-- vim.keymap.set("n", "<leader>9", ":horizontal resize +4<CR>")
-- vim.keymap.set("n", "<leader>0", ":horizontal resize -4<CR>")
-- vim.keymap.set("n", "<leader>1", ":vertical resize +4<CR>")
-- vim.keymap.set("n", "<leader>2", ":vertical resize -4<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Nvimtree
vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFileToggle<cr>")

-- NeoGit
vim.keymap.set("n", "<leader>ng", "::Neogit kind=vsplit <cr>")

-- Center screen when using <C-u> and <C-d>
vim.keymap.set({ "n", "i", "c" }, "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set({ "n", "i", "c" }, "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

