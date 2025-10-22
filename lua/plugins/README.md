# Plugin Configuration

## Structure

This directory contains modular plugin configurations for Neovim using [Lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

- **Individual plugin configs** are in separate files (e.g., `lsp.lua`, `telescope.lua`)
- **Lazy.nvim automatically loads** all `.lua` files in this directory
- **Subdirectories** (like `archive/`) are NOT automatically loaded
- Each file should **return a Lazy.nvim plugin spec table**

## Active Plugins

### LSP & Completion
- **lsp.lua** - LSP configuration with Mason, LSP servers, keybindings, and custom hover handler
- **completions.lua** - nvim-cmp autocompletion with LuaSnip snippets
- **copilot.lua** - GitHub Copilot integration (requires Node.js >= 22.2.0)

### UI & Navigation
- **telescope.lua** - Fuzzy finder for files, grep, and more
- **nvim-tree.lua** - File explorer
- **trouble.lua** - Diagnostic and quickfix list
- **harpoon.lua** - Quick file navigation marks
- **incline.lua** - Custom status bar in window borders

### Code Quality
- **conform.lua** - Code formatting (prettier, stylua, black, isort, etc.)
- **treesitter.lua** - Syntax highlighting and parsing
- **blankline.lua** - Indent guides with rainbow colors

### Git Integration
- **gitsigns.lua** - Git signs in gutter with custom keybindings

### Theme & Appearance
- **colorscheme.lua** - Rose Pine theme configuration

### Utilities
- **personal.lua** - Custom plugins (ohne-accidents, octopus)
- **plugins.lua** - Misc plugins (colorizer, markdown-preview, css-vars, Comment, neogit, diffview)

## Plugin Patterns

### Basic Plugin (Auto-setup)
```lua
return {
  "author/plugin-name",
  opts = {
    -- Plugin options here
  }
}
```
> Lazy.nvim automatically calls `require('plugin-name').setup(opts)`

### Plugin with Custom Config
```lua
return {
  "author/plugin-name",
  config = function()
    require('plugin-name').setup({
      -- Custom configuration
    })
  end
}
```

### Plugin with Dependencies
```lua
return {
  "author/plugin-name",
  dependencies = {
    "author/dependency-1",
    { "author/dependency-2", opts = {} },
  },
  config = function()
    require('plugin-name').setup({})
  end
}
```

### Plugin with Lazy Loading
```lua
return {
  "author/plugin-name",
  event = "VeryLazy",  -- Load on VeryLazy event
  -- OR
  cmd = "PluginCommand",  -- Load when command is run
  -- OR
  keys = {  -- Load when key is pressed
    { "<leader>x", "<cmd>Command<cr>", desc = "Description" },
  },
  config = function()
    require('plugin-name').setup({})
  end
}
```

## Adding New Plugins

1. **Create new file** in this directory: `lua/plugins/plugin-name.lua`
2. **Return Lazy.nvim spec table** following patterns above
3. **Restart Neovim** to load the new configuration
4. **Run `:Lazy sync`** to install the plugin

Example:
```bash
# Create new plugin file
touch lua/plugins/new-plugin.lua

# Edit the file
nvim lua/plugins/new-plugin.lua
```

```lua
-- lua/plugins/new-plugin.lua
return {
  "author/new-plugin",
  opts = {
    enable = true,
  }
}
```

## Managing Plugins

### Update All Plugins
```vim
:Lazy sync
```

### Update Specific Plugin
```vim
:Lazy update plugin-name
```

### View Plugin Status
```vim
:Lazy
```

### Clean Unused Plugins
```vim
:Lazy clean
```

## Archived Plugins

Disabled/experimental plugins are stored in `archive/` subdirectory.
See [`archive/README.md`](./archive/README.md) for details on archived plugins.

## Configuration Files

| File | Purpose | Key Features |
|------|---------|--------------|
| `lsp.lua` | LSP configuration | Mason, LSP servers, keybindings, hover handler |
| `completions.lua` | Autocompletion | nvim-cmp, LuaSnip, sources |
| `copilot.lua` | AI completion | GitHub Copilot (Node.js >= 22.2.0 required) |
| `telescope.lua` | Fuzzy finder | File search, grep, LSP pickers |
| `treesitter.lua` | Syntax highlighting | Auto-install parsers, incremental selection |
| `conform.lua` | Code formatting | Multiple formatters, format on save |
| `gitsigns.lua` | Git integration | Signs, hunks, blame, diff |
| `nvim-tree.lua` | File explorer | Tree view with icons |
| `trouble.lua` | Diagnostics | Diagnostic panel, quickfix |
| `harpoon.lua` | Navigation | Quick file marks |
| `incline.lua` | Status bar | Custom window border status |
| `blankline.lua` | Indentation | Rainbow indent guides |
| `colorscheme.lua` | Theme | Rose Pine configuration |
| `personal.lua` | Custom plugins | Local/custom plugins |
| `plugins.lua` | Misc plugins | Utilities and small plugins |

## Notes

- **Leader key** is set to `<Space>` in `init.lua`
- **Keybindings** are defined in individual plugin files and `lua/remap.lua`
- **LSP servers** are auto-installed via Mason
- **Formatters** are configured in `conform.lua`
- **Custom functions** (like ColorMyPencils) are in `lua/settings.lua`

## Troubleshooting

### Plugin not loading
1. Check file is in `lua/plugins/` (not in subdirectory)
2. Verify file returns a valid Lazy.nvim spec
3. Restart Neovim
4. Run `:Lazy sync`

### LSP not working
1. Check `:LspInfo` for active clients
2. Verify LSP server is installed: `:Mason`
3. Check keybindings in `lua/plugins/lsp.lua`

### Formatting not working
1. Check formatter is installed: `:Mason`
2. Verify configuration in `conform.lua`
3. Try manual format: `<leader>+`

## Resources

- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Mason.nvim Documentation](https://github.com/williamboman/mason.nvim)
- [nvim-lspconfig Documentation](https://github.com/neovim/nvim-lspconfig)
