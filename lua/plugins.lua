-- Packer bootstrap
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer
    use 'wbthomason/packer.nvim'

    -- LSP, DAP, Linters, Formatters
    use {
        -- LSP
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'neovim/nvim-lspconfig',
        -- Syntax Highlighting
        'nvim-treesitter/nvim-treesitter',
        -- Debug Adapter Protocol
        'mfussenegger/nvim-dap',
        -- Linters, Formatters
        'jose-elias-alvarez/null-ls.nvim',
    }

    use { 'WhoIsSethDaniel/mason-tool-installer.nvim',
        as = 'mason-tool-installer',
        config = function()
            require 'mason-tool-installer'.setup({
                ensure_installed = {
                    'lua-language-server',
                    'vim-language-server',
                },
                auto_update = true,
            })
        end
    }

    -- Visualize lsp progress
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end
    })
    -- nice UI for LSP
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            local saga = require("lspsaga")

            saga.init_lsp_saga({
                -- your configuration
            })
        end,
    })

    -- Autopairs
    use { 'windwp/nvim-autopairs', config = function() require 'nvim-autopairs'.setup() end }
    use { 'windwp/nvim-ts-autotag', config = function() require 'nvim-ts-autotag'.setup() end }
    -- use { 'HiPhish/nvim-ts-rainbow2',
    --     requires = 'nvim-treesitter/nvim-treesitter' }
    use { 'p00f/nvim-ts-rainbow' }

    -- Buffer line
    use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons',
        config = function() require 'bufferline'.setup() end }

    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function() require 'lualine'.setup({
                theme = 'ayu_mirage'
            })
        end
    }

    -- Reference for Rust setup
    -- https://sharksforarms.dev/posts/neovim-rust/
    use("simrat39/rust-tools.nvim")

    -- Autocomplete
    use("hrsh7th/nvim-cmp")
    use({
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/vim-vsnip",
        after = { "hrsh7th/nvim-cmp" },
        requires = { "hrsh7th/nvim-cmp" },
    })

    -- Comments
    use {
        "numToStr/Comment.nvim",
        config = function() require 'Comment'.setup() end
    }

    -- WhichKey (quick commands)
    use {
        "folke/which-key.nvim",
        config = function() require 'which-key'.setup {
                triggers = { "<leader>", ' ' }
            }
        end
    }

    -- Telescope (fuzzy find)
    use("nvim-telescope/telescope.nvim")

    -- File trees
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    -- Neovim Extensions
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")

    -- Session management
    use {
        'rmagatti/auto-session',
        config = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
            require("auto-session").setup {
                log_level = "error",
                auto_session_enable_last_session = true,
                auto_save_enabled = true,
                auto_restore_enabled = true,

            }
        end
    }
    use {
        'rmagatti/session-lens',
        requires = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
        config = function() require 'session-lens'.setup({}) end
    }

    -- Terminal
    use {
        "akinsho/toggleterm.nvim", tag = '*',
        config = function()
            require("toggleterm").setup {
                open_mapping = [[<c-\>]],
                direction = "vertical",
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
            }
        end
    }

    -- Colorschemes
    use { 'navarasu/onedark.nvim', as = 'onedark' }
    use { 'tanvirtin/monokai.nvim', as = 'monokai' }
    use { 'Everblush/nvim', as = 'everblush' }
    use { 'AhmedAbdulrahman/aylin.vim', as = 'aylin' }
    use { 'Shatur/neovim-ayu', as = 'ayu' }

    -- Packer Bootstrap
    if packer_bootstrap then
        require('packer').sync()
    end
end)
