-- which-key mappings
vim.g.mapleader = ' '
local telescope_builtin = require 'telescope.builtin'
require 'which-key'.register({
    -- (l)sp
    l = {
        name = "LSP",
        l = { function() vim.cmd("Lspsaga hover_doc") end, "Hover" },
        a = { function() vim.cmd("Lspsaga code_action") end, "Code Action" },
        d = {
            name = "Definitions",
            d = { vim.lsp.buf.definition, "Go to Symbol Definition" },
            t = { vim.lsp.buf.type_definition, "Go to Type Definition" },
            p = { function() vim.cmd("Lspsaga peek_definition") end, "Peek Definition" },
        },
        e = {
            name = "Error Diagnostics",
            L = { function() vim.cmd("Lspsaga show_line_diagnostics") end, "Show Line Diagnostics" },
            e = { function() vim.cmd("Lspsaga show_cursor_diagnostics") end, "Show Cursor Diagnostics" },
            h = { function() vim.cmd("Lspsaga diagnostics_jump_previous") end, "Jump to Previous Diagnostics" },
            l = { function() vim.cmd("Lspsaga diagnostics_jump_next") end, "Jump to Next Diagnostic" },
        },
        r = {
            function() vim.cmd("Lspsaga rename") end, "Rename Symbol",
        },
        o = {
            function() vim.cmd("Lspsaga outline") end, "Toggle Outline",
        },
    },
    -- (f)ind
    f = {
        name = "Find",
        f = { telescope_builtin.find_files, "Find Files" },
        g = { telescope_builtin.live_grep, "Live Grep", },
        b = { telescope_builtin.buffers, "Buffers", },
        h = { telescope_builtin.help_tags, "Help Tags", },
        s = { function() vim.cmd("SearchSession") end, "Sessions" },
    },
    -- (c)onfiguration
    c = {
        name = "Configuration",
        e = {
            name = "Edit",
            i = { function() vim.cmd("e ~/.config/nvim/init.lua") end, "init.lua" },
            p = { function() vim.cmd("e ~/.config/nvim/lua/plugins.lua") end, "plugins.lua", },
            l = { function() vim.cmd("e ~/.config/nvim/lua/lsp.lua") end, "lsp.lua", },
            k = { function() vim.cmd("e ~/.config/nvim/lua/keymaps.lua") end, "keymaps.lua" },
        },
        P = {
            name = "Packer",
            S = { function() vim.cmd("PackerSync") end, "Sync" },
            c = { function() vim.cmd("PackerCompile") end, "Compile" },
            i = { function() vim.cmd("PackerInstall") end, "Install" },
            s = { function() vim.cmd("PackerStatus") end, "Status" },
        },
        M = { function() vim.cmd("Mason") end, "Open Mason" },
        s = { function()
            vim.cmd("source $MYVIMRC")
            vim.cmd("PackerSync")
        end, "Source $MYVIMRC and Update Packages" }
    },
    -- (t)abs
    t = {
        name = "Tabs/Buffers",
        c = { function() vim.cmd("BufferLinePickClose") end, "Pick-Close Tab" },
        q = { function() vim.cmd("bp | sp | bn | bd") end, "Close Current Tab" }, -- http://stackoverflow.com/questions/1444322/ddg#8585343
        p = { function() vim.cmd("BufferLinePick") end, "Pick Tab" },
        k = { function() vim.cmd("BufferLineCycleNext") end, "Next Tab", },
        j = { function() vim.cmd("BufferLineCyclePrev") end, "Previous Tab" },
    },
    w = {
        function() vim.cmd("w") end, "Write Buffer"
    }
}, {
    prefix = "<leader>",
})
-- custom mappings
-- Focus NvimTree if already open and not focused, otherwise toggle.
vim.keymap.set("n", "<C-b>", function()
    -- buffer 0 is current buffer
    if require 'nvim-tree.utils'.is_nvim_tree_buf(0) then
        vim.cmd('NvimTreeClose')
    else
        vim.cmd('NvimTreeFocus')
    end
end)
vim.keymap.set('n', '<C-k>', function() vim.cmd("BufferLineCycleNext") end)
vim.keymap.set('n', '<C-j>', function() vim.cmd("BufferLineCyclePrev") end)
