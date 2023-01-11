-- other files
require('plugins');
require('lsp');

-- format on save
vim.api.nvim_create_autocmd(
    { "BufWritePre" },
    { callback = function()
        vim.lsp.buf.format()
    end })

-- plugin setup
-- nvim-tree (file browser)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require 'nvim-tree'.setup()
vim.api.nvim_create_autocmd("DirChanged", {
    callback = function(cwd, _scope, _changed_window)
        vim.cmd("NvimTreeOpen " .. vim.cmd('pwd'), { silent = true })
    end
})

-- nvim-treesitter setup
require 'nvim-treesitter.configs'.setup({
    highlight = {
        enable = true,
    },
    rainbow = {
        enable = true,
        query = {
            'rainbow-parens',
            'rainbow-tags',
        },
        extended_mode = true,
    }
})

-- display
-- -- colorscheme
vim.o.termguicolors = true
vim.cmd('colorscheme ayu-mirage');
-- -- tabs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
-- -- hybrid line numbers
vim.o.nu = true
vim.o.rnu = true
-- -- neovide
if vim.g.neovide then
    vim.g.neovide_fullscreen = true
    vim.g.remember_window_size = true
    vim.o.guifont = "UbuntuMono Nerd Font:h11:#h-full" -- "Lotion:h12:#h-normal"
end

-- keymaps must come after all plugin setup
require('keymaps')
