# Archived Plugin Configurations

These plugins are disabled/experimental and not currently loaded by Lazy.nvim.

**Note:** Lazy.nvim only auto-loads plugin files in the top-level `lua/plugins/` directory, not subdirectories.

## How to Re-enable a Plugin

1. Move the file back to `lua/plugins/`
2. Restart Neovim
3. Run `:Lazy sync`

## Archived Plugins

- **copilot-chat.lua** - Copilot Chat integration (alternative interface to copilot.lua)
- **blink.lua** - Alternative completion engine (experimental replacement for nvim-cmp)
- **multicursor.lua** - Multiple cursor support for simultaneous editing
- **zenmode.lua** - Focus/zen mode for distraction-free writing
- **which-key.lua** - Keybinding helper that shows available commands
- **markview.lua** - Enhanced markdown previewer
- **neotest.lua** - Test runner integration for various testing frameworks

## Why These Are Archived

These configurations were either:
- Experimental features being tested
- Alternatives to currently active plugins
- Features that weren't being actively used
- Plugins that conflicted with current setup

Feel free to re-enable any of these if you want to try them again!
