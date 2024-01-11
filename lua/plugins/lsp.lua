return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- (Optional) Configure lua language server for neovim
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                }
            })
        end
    }
    -- { "onsails/lspkind.nvim" },
    --
    -- { "simrat39/rust-tools.nvim" },
    --
    -- {
    --     'VonHeikemen/lsp-zero.nvim',
    --     branch = 'v3.x',
    --     lazy = true,
    --     dependencies = {
    --         --- Uncomment these if you want to manage LSP servers from neovim
    --         { 'williamboman/mason.nvim' },
    --         { 'williamboman/mason-lspconfig.nvim' },
    --
    --         -- LSP Support
    --         { 'neovim/nvim-lspconfig' },
    --         -- Autocompletion
    --         { 'hrsh7th/nvim-cmp' },
    --         { 'hrsh7th/cmp-nvim-lsp' },
    --         {
    --             'L3MON4D3/LuaSnip',
    --             tag = "v2.*",
    --             run = "make install_jsregexp",
    --             dependencies = { "rafamadriz/friendly-snippets" },
    --         },
    --         { 'hrsh7th/cmp-buffer' },       -- Optional
    --         { 'hrsh7th/cmp-path' },         -- Optional
    --         { 'saadparwaiz1/cmp_luasnip' }, -- Optional
    --         { 'hrsh7th/cmp-nvim-lua' },     -- Optional
    --
    --         -- Snippets
    --         { 'L3MON4D3/LuaSnip' },             -- Required
    --         { 'rafamadriz/friendly-snippets' }, -- Optional
    --     },
    --     keybindings = function()
    --         local lsp_zero = require('lsp-zero')
    --         lsp_zero.on_attach(function(client, bufnr)
    --             -- see :help lsp-zero-keybindings
    --             -- to learn the available actions
    --             lsp_zero.default_keymaps({ buffer = bufnr })
    --         end)
    --     end,
    --     config = function()
    --         local lsp_zero = require('lsp-zero')
    --
    --         lsp_zero.on_attach(function(client, bufnr)
    --             -- see :help lsp-zero-keybindings
    --             -- to learn the available actions
    --             lsp_zero.default_keymaps({ buffer = bufnr })
    --         end)
    --
    --         require('mason').setup({
    --             'tsserver',
    --             'eslint',
    --             'lua_ls',
    --             'solargraph',
    --         })
    --         require('mason-lspconfig').setup({
    --             ensure_installed = {
    --                 'tsserver',
    --                 'eslint',
    --                 'lua_ls',
    --                 'solargraph',
    --             },
    --             handlers = {
    --                 lsp_zero.default_setup,
    --             },
    --         })
    --
    --         require("luasnip.loaders.from_vscode").lazy_load()
    --
    --         local lspkind = require('lspkind')
    --         local luasnip = require 'luasnip'
    --
    --         luasnip.config.setup {}
    --
    --         local cmp = require('cmp')
    --         local cmp_format = require('lsp-zero').cmp_format()
    --         cmp.setup {
    --             snippet = {
    --                 expand = function(args)
    --                     luasnip.lsp_expand(args.body)
    --                 end
    --             },
    --             sources = {
    --                 { name = "friendly-snippets" },
    --                 { name = 'nvim_lsp' },
    --                 { name = 'luasnip' },
    --
    --                 -- { name = "vsnip",             group_index = 2 },
    --                 -- Copilot Source
    --                 -- { name = "copilot",           group_index = 2 },
    --                 -- Other Sources
    --                 -- { name = "nvim_lsp",          group_index = 2 },
    --                 -- { name = "path",              group_index = 2 },
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 -- confirm completion
    --                 ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    --
    --                 -- scroll up and down the documentation window
    --                 ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    --                 ['<C-d>'] = cmp.mapping.scroll_docs(4),
    --             }),
    --             -- formatting = cmp_format,
    --             formatting = {
    --                 format = lspkind.cmp_format({
    --                     mode = 'symbol_text',  -- show only symbol annotations
    --                     maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
    --                     -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
    --                     ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    --                 })
    --             },
    --             window = {
    --                 completion = cmp.config.window.bordered(),
    --                 documentation = cmp.config.window.bordered(),
    --             },
    --         }
    --     end
    -- },
}
