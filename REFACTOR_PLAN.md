# Neovim Configuration Refactor Plan

**Generated:** 2025-10-22
**Config Location:** `/Users/a.blum/.config/nvim`

---

## Overview

This refactor addresses critical issues, removes technical debt, and improves maintainability of your Neovim configuration. Changes are organized into 4 phases prioritized by risk and impact.

**Total Estimated Time:** 2-3 hours
**Risk Level:** Low (all changes are reversible via git)

---

## Phase 1: Critical Fixes (Est. 15 minutes)

### 1.1 Remove Duplicate Keybindings

**File:** `lua/remap.lua`

**Issue:** Same keybinding defined multiple times, causing confusion.

**Changes:**
- **Line 70:** Remove duplicate `jk` → ESC mapping (already defined at line 21)
- **Lines 31-32:** Remove basic `<C-u>` and `<C-d>` mappings (enhanced versions exist at lines 97-98)

**Before (lines 31-32):**
```lua
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
```

**After:** Delete these lines (keep enhanced versions at 97-98)

**Impact:** No functional change, cleaner code

---

### 1.2 Fix Deprecated API Calls

**File:** `init.lua`

**Issue:** Using deprecated `vim.api.nvim_win_set_option` (removed in Neovim 0.10+)

**Changes:**
- **Line 103:** Update to new API

**Before:**
```lua
vim.api.nvim_win_set_option(winnr, 'winblend', 0)
```

**After:**
```lua
vim.api.nvim_set_option_value('winblend', 0, { win = winnr })
```

**Impact:** Future-proof, removes deprecation warning

---

### 1.3 Document Copilot Node.js Version Requirement

**File:** `lua/plugins/copilot.lua`

**Issue:** Hardcoded specific version (22.20.0) with no explanation

**Changes:**
- **Line 53:** Add comment explaining this is a Copilot-specific requirement

**Before:**
```lua
copilot_node_command = vim.fn.expand('~/.asdf/installs/nodejs/22.20.0/bin/node'),
```

**After:**
```lua
-- GitHub Copilot requires Node.js >= 22.2.0
-- Update this path when changing Node.js versions
copilot_node_command = vim.fn.expand('~/.asdf/installs/nodejs/22.20.0/bin/node'),
```

**Impact:** Documents that this is a Copilot requirement, not a general Neovim requirement

---

## Phase 2: Configuration Cleanup (Est. 30 minutes)

### 2.1 Consolidate LSP Configuration

**Issue:** LSP setup fragmented across multiple files

**Current State:**
- `init.lua` (lines 43-114): LSP autocmd with custom K hover handler
- `lua/plugins/lsp.lua`: Main LSP server configuration

**Plan:**
1. Move LSP autocmd from `init.lua` to `lua/plugins/lsp.lua`
2. Move custom K hover handler to `lua/plugins/lsp.lua`
3. Keep only Lazy.nvim bootstrap in `init.lua`

**New Structure:**
```
init.lua
├── Bootstrap Lazy.nvim
├── Set leader keys
├── Require settings
└── Require remap

lua/plugins/lsp.lua
├── LSP server configurations
├── Mason setup
├── LSP autocmd (on_attach logic)
└── Custom hover handler
```

**Files Modified:**
- `init.lua`: Remove lines 43-114
- `lua/plugins/lsp.lua`: Add LSP autocmd and hover handler

**Impact:** Single source of truth for LSP, easier to maintain

---

### 2.2 Archive Disabled Plugin Files

**Issue:** 7 plugin files completely disabled (315 lines)

**Files to Archive:**
1. `lua/plugins/copilot-chat.lua` (81 lines)
2. `lua/plugins/blink.lua` (30 lines)
3. `lua/plugins/multicursor.lua` (104 lines)
4. `lua/plugins/zenmode.lua` (35 lines)
5. `lua/plugins/which-key.lua` (19 lines)
6. `lua/plugins/markview.lua` (13 lines)
7. `lua/plugins/neotest.lua` (33 lines)

**Plan:**
1. Create `lua/plugins/archive/` directory
2. Move all disabled plugin files there
3. Add `lua/plugins/archive/README.md` explaining these are disabled experiments
4. Lazy.nvim won't load files in subdirectories automatically

**Commands:**
```bash
mkdir -p lua/plugins/archive
mv lua/plugins/{copilot-chat,blink,multicursor,zenmode,which-key,markview,neotest}.lua lua/plugins/archive/
```

**Archive README Content:**
```markdown
# Archived Plugin Configurations

These plugins are disabled/experimental and not currently loaded.

To re-enable a plugin:
1. Move the file back to `lua/plugins/`
2. Restart Neovim
3. Run `:Lazy sync`

## Archived Plugins

- **copilot-chat.lua** - Copilot Chat integration (alternative to copilot.lua)
- **blink.lua** - Alternative completion engine
- **multicursor.lua** - Multiple cursor support
- **zenmode.lua** - Focus/zen mode
- **which-key.lua** - Keybinding helper
- **markview.lua** - Markdown previewer
- **neotest.lua** - Test runner integration
```

**Impact:** Cleaner main plugins directory, easy to restore if needed

---

### 2.3 Consolidate Diagnostic Configuration

**Issue:** Diagnostic configuration split between files

**Current State:**
- `lua/plugins/completions.lua` (lines 68-78): Sets diagnostic UI config
- `lua/settings.lua` (lines 48-58): Defines diagnostics toggle function

**Plan:**
1. Move all diagnostic configuration to `lua/settings.lua`
2. Keep UI config and toggle function together

**Files Modified:**
- `lua/plugins/completions.lua`: Remove lines 68-78
- `lua/settings.lua`: Add diagnostic UI config from completions.lua

**Impact:** All diagnostic settings in one place

---

### 2.4 Fix ColorMyPencils Function

**Issue:** Function defined in colorscheme.lua but referenced in disabled zenmode.lua

**Current State:**
- Defined in `lua/plugins/colorscheme.lua` (lines 1-4)
- Referenced in `lua/plugins/zenmode.lua` (will be archived)

**Plan:**
1. Move `ColorMyPencils` function to `lua/settings.lua`
2. Make it globally available
3. Update reference in `colorscheme.lua`

**Before (colorscheme.lua):**
```lua
function ColorMyPencils(color)
  -- function code
end
```

**After (settings.lua):**
```lua
-- Color scheme utility
function _G.ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
```

**After (colorscheme.lua):**
```lua
config = function()
  -- setup code
  _G.ColorMyPencils()
end
```

**Impact:** Reusable utility function, available globally

---

## Phase 3: Code Organization (Est. 45 minutes)

### 3.1 Reorganize remap.lua with Logical Grouping

**File:** `lua/remap.lua`

**Issue:** 99 lines of keybindings with no logical organization

**Plan:** Add section comments and group related keybindings

**New Structure:**
```lua
-- ========================================
-- KEY MAPPINGS
-- ========================================

-- ----------------------------------------
-- GENERAL EDITOR
-- ----------------------------------------
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-l>", "<cmd>noh<CR>")
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set({"n", "v"}, "<leader>a", "ggVG", { desc = "Select All" })

-- ----------------------------------------
-- WINDOW MANAGEMENT
-- ----------------------------------------
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "Split Vertical" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "Split Horizontal" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { desc = "Move to Window Above" })
-- ... etc

-- ----------------------------------------
-- NAVIGATION & SCROLLING
-- ----------------------------------------
vim.keymap.set({ "n", "i", "c" }, "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set({ "n", "i", "c" }, "<C-d>", "<C-d>zz", { desc = "Scroll Down" })

-- ----------------------------------------
-- TEXT EDITING
-- ----------------------------------------
vim.keymap.set("n", "<A-j>", ":MoveLine(1)<CR>", { desc = "Move Line Down" })
vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<CR>", { desc = "Move Line Up" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete to Void Register" })

-- ----------------------------------------
-- CODE ACTIONS
-- ----------------------------------------
vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format() end, { desc = "Format Buffer" })

-- ----------------------------------------
-- FILE TREE & GIT
-- ----------------------------------------
vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>", { desc = "Toggle File Tree" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Neogit, { desc = "Open Neogit" })

-- ----------------------------------------
-- SEARCH & REPLACE
-- ----------------------------------------
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and Replace" })

-- ----------------------------------------
-- QUICK EXIT
-- ----------------------------------------
vim.keymap.set("n", "ZZ", "<cmd>qa<CR>", { desc = "Quit All" })
```

**Impact:** Much easier to find and maintain keybindings

---

### 3.2 Standardize Code Style

**Issue:** Inconsistent patterns throughout config

**Changes:**

#### 3.2.1 Standardize Option Setting
**Guideline:** Use `vim.opt` for options, `vim.g` for globals

**Files to update:** `lua/settings.lua`, `init.lua`

**Before (mixed):**
```lua
vim.opt.number = true
vim.o.formatexpr = "..."
```

**After (consistent):**
```lua
vim.opt.number = true
vim.opt.formatexpr = "..."
```

#### 3.2.2 Standardize Require Patterns
**Guideline:** Store in local variable for multiple uses, inline for single use

**Before (unnecessary local):**
```lua
local conform = require('conform')
conform.setup({ ... })
```

**After (inline for single use):**
```lua
require('conform').setup({ ... })
```

**Impact:** More readable and consistent code

---

### 3.3 Add Plugin Loading Documentation

**New File:** `lua/plugins/README.md`

**Content:**
```markdown
# Plugin Configuration

## Structure

- Individual plugin configs are in separate files (e.g., `lsp.lua`, `telescope.lua`)
- Lazy.nvim automatically loads all files in this directory
- Each file should return a Lazy.nvim plugin spec table
- Subdirectories (like `archive/`) are NOT automatically loaded

## Active Plugins

- **lsp.lua** - LSP configuration with Mason
- **completions.lua** - nvim-cmp autocompletion
- **copilot.lua** - GitHub Copilot
- **telescope.lua** - Fuzzy finder
- **treesitter.lua** - Syntax highlighting
- **gitsigns.lua** - Git integration
- **conform.lua** - Code formatting
- **colorscheme.lua** - Rose Pine theme
- **nvim-tree.lua** - File explorer
- **trouble.lua** - Diagnostic list
- **harpoon.lua** - Quick navigation
- **incline.lua** - Status bar
- **blankline.lua** - Indent guides
- **personal.lua** - Custom plugins (ohne-accidents, octopus)
- **plugins.lua** - Misc plugins (colorizer, markdown-preview, css-vars)

## Plugin Patterns

### Basic Plugin
```lua
return {
  "author/plugin-name",
  opts = { ... }  -- Lazy.nvim calls setup() automatically
}
```

### Plugin with Custom Config
```lua
return {
  "author/plugin-name",
  config = function()
    require('plugin-name').setup({ ... })
  end
}
```

### Plugin with Dependencies
```lua
return {
  "author/plugin-name",
  dependencies = {
    "author/dependency",
  },
  config = function()
    require('plugin-name').setup({ ... })
  end
}
```

## Adding New Plugins

1. Create new file: `lua/plugins/plugin-name.lua`
2. Return Lazy.nvim spec table
3. Restart Neovim
4. Run `:Lazy sync`

## Archived Plugins

Disabled/experimental plugins are in `archive/` subdirectory.
See `archive/README.md` for details.
```

**Impact:** Easier for others (and future you) to understand config

---

## Phase 4: Optional Improvements (Est. 30 minutes)

### 4.1 Clean Up Gitsigns Deprecated API

**File:** `lua/plugins/gitsigns.lua`

**Issue:** Using deprecated virtual text API (lines 69, 95, 103)

**Plan:**
- Update inline diff to use extmarks or virtual lines API
- Remove debug print statements (lines 89, 91)
- Fix unreachable code with goto label

**Impact:** Future-proof, cleaner implementation

**Note:** This is complex and low priority. Can skip if current implementation works.

---

### 4.2 Create Backup and Rollback Strategy

**Before starting refactor:**

```bash
# Create tagged backup
cd ~/.config/nvim
git add -A
git commit -m "Pre-refactor snapshot"
git tag pre-refactor-2025-10-22

# If needed to rollback:
git reset --hard pre-refactor-2025-10-22
```

**Impact:** Safe rollback option

---

## Implementation Order

### Recommended Sequence:

1. **Create git backup** (Phase 4.2)
2. **Phase 1** - Critical fixes (safe, no dependencies)
3. **Phase 2.2** - Archive disabled files (clean slate)
4. **Phase 2.1** - Consolidate LSP (biggest structural change)
5. **Phase 2.3** - Consolidate diagnostics
6. **Phase 2.4** - Fix ColorMyPencils
7. **Phase 3.1** - Reorganize remap.lua
8. **Phase 3.2** - Standardize code style
9. **Phase 3.3** - Add documentation
10. **Phase 4.1** - Optional: gitsigns cleanup (SKIP)

---

## File Change Summary

| File | Action | Lines Changed | Risk |
|------|--------|---------------|------|
| `lua/remap.lua` | Edit | ~5 removals, reorganize | Low |
| `init.lua` | Edit | ~72 removals, 1 update | Medium |
| `lua/plugins/lsp.lua` | Edit | ~80 additions | Medium |
| `lua/plugins/copilot.lua` | Edit | Add comment | Low |
| `lua/plugins/completions.lua` | Edit | ~10 removals | Low |
| `lua/settings.lua` | Edit | ~20 additions | Low |
| `lua/plugins/colorscheme.lua` | Edit | ~5 changes | Low |
| `lua/plugins/archive/*.lua` | Move | 7 files, 315 lines | Low |
| `lua/plugins/archive/README.md` | Create | New file | None |
| `lua/plugins/README.md` | Create | New file | None |

**Total:** ~450 lines reorganized/moved, ~100 lines added

---

## Testing Plan

After each phase:

1. Restart Neovim: `nvim`
2. Check for errors: `:checkhealth`
3. Test LSP: Open a file, trigger `K` hover, `gd` go to definition
4. Test completions: Type in insert mode, verify cmp works
5. Test keybindings: Try common mappings (`<leader>ff`, `<C-u>`, `jk`)
6. Test plugins: `:Lazy`, verify all plugins loaded

---

## Rollback Instructions

If any phase causes issues:

```bash
# Rollback to pre-refactor state
cd ~/.config/nvim
git reset --hard pre-refactor-2025-10-22

# Restart Neovim
nvim
```

---

## Summary of User Preferences

- ✅ Keep Node.js version requirement >= 22.2 for Copilot
- ✅ Archive disabled plugins instead of deleting
- ✅ Skip optional gitsigns API cleanup (Phase 4.1)

---

## Next Steps

Ready to execute! I will:
1. Create git backup
2. Execute Phases 1-3 (skipping Phase 4.1)
3. Test after each phase
4. Provide summary of changes

**Total estimated time:** ~1.5 hours

Please confirm and I'll begin the refactor.
