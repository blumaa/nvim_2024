return {

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    'MunifTanjim/prettier.nvim',

    'jose-elias-alvarez/null-ls.nvim',

    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end
    },

    'JoosepAlviste/nvim-ts-context-commentstring',

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({})
            vim.cmd.colorscheme "catppuccin-mocha"
        end,
    },

    'nvim-lua/plenary.nvim',

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            {
                '<leader>ff', ':Telescope find_files<cr>'
            },
            {
                '<leader>fg', ':Telescope live_grep<cr>'
            }
        },

    },

    {
        "nvim-tree/nvim-web-devicons", lazy = true
    },

}
