-- ========================================
-- KEY MAPPINGS
-- ========================================

-- ----------------------------------------
-- GENERAL EDITOR
-- ----------------------------------------
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
vim.keymap.set('n', '<leader>q', ':nohlsearch<CR>', { noremap = true, silent = true, desc = "Clear search highlight" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undo Tree" })

-- ----------------------------------------
-- WINDOW MANAGEMENT
-- ----------------------------------------
-- Create splits
vim.keymap.set("n", "<leader>-", ":vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>_", ":split<cr>", { desc = "Horizontal Split" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to Left Window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to Bottom Window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to Top Window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to Right Window" })

-- Resize splits
vim.keymap.set({ "n", "v", "x" }, "<S-Down>", "<cmd>resize -2<cr>", { desc = "Resize Split Down" })
vim.keymap.set({ "n", "v", "x" }, "<S-Up>", "<cmd>resize +2<cr>", { desc = "Resize Split Up" })
vim.keymap.set({ "n", "v", "x" }, "<S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Resize Split Left" })
vim.keymap.set({ "n", "v", "x" }, "<S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize Split Right" })

-- ----------------------------------------
-- NAVIGATION & SCROLLING
-- ----------------------------------------
-- Center screen when scrolling
vim.keymap.set({ "n", "i", "c" }, "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set({ "n", "i", "c" }, "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

-- Location list navigation
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Location" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous Location" })

-- ----------------------------------------
-- TEXT EDITING
-- ----------------------------------------
-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up" })

-- Join line below to current line
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join Lines" })

-- Duplicate line and comment original
vim.keymap.set('n', 'ycc', 'yygccp', { noremap = true, silent = true, desc = "Duplicate and Comment Line" })

-- Selection and copying
vim.keymap.set("n", "vA", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "yA", "ggVGy", { desc = "Copy All" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank Line to System Clipboard" })

-- Delete to void register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to Void Register" })

-- ----------------------------------------
-- CODE ACTIONS
-- ----------------------------------------
-- Formatting
vim.keymap.set("n", "<leader>=", ":EslintFixAll<CR>", { desc = "ESLint Fix All" })
vim.keymap.set("n", "<leader>+", vim.lsp.buf.format, { desc = "Format Buffer" })

-- LSP references
vim.keymap.set("n", "<leader>tr", ":Telescope lsp_references<CR>", { desc = "LSP References" })

-- ----------------------------------------
-- FILE TREE & GIT
-- ----------------------------------------
-- NvimTree
vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<cr>", { desc = "Toggle File Tree" })
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFileToggle<cr>", { desc = "Find File in Tree" })

-- NeoGit
vim.keymap.set("n", "<leader>ng", "::Neogit kind=vsplit <cr>", { desc = "Open Neogit" })

-- ----------------------------------------
-- SEARCH & REPLACE
-- ----------------------------------------
-- Search and replace current word
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and Replace Word" })

-- ----------------------------------------
-- FILE OPERATIONS
-- ----------------------------------------
-- Make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make File Executable" })

-- Quick save and exit
vim.keymap.set("n", "<DOWN>", ":w<CR>", { desc = "Quick Save" })
vim.keymap.set("n", "<RIGHT>", ":q<CR>", { desc = "Quick Quit" })
vim.keymap.set("n", "fd", ":q<CR>", { desc = "Quick Quit" })

-- ----------------------------------------
-- COMMENTED OUT / DISABLED MAPPINGS
-- ----------------------------------------
-- vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>cf', function()
--   vim.lsp.buf.format({ async = true, name = "prettierd" })
-- end, { noremap = true, silent = true })
-- vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
-- vim.keymap.set('n', '<leader>d', ':call v:lua.toggle_diagnostics()<CR>')
-- vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile -strategy=neovim<CR>', { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>gt", ":A<cr>")
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set("n", "<leader>pr", ":Prettier<CR>")
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>9", ":horizontal resize +4<CR>")
-- vim.keymap.set("n", "<leader>0", ":horizontal resize -4<CR>")
-- vim.keymap.set("n", "<leader>1", ":vertical resize +4<CR>")
-- vim.keymap.set("n", "<leader>2", ":vertical resize -4<CR>")
