-- which-key mappings
vim.g.mapleader = ' '
local telescope_builtin = require 'telescope.builtin'
local register = require 'which-key'.register

local leader_mappings = {
    -- (l)sp info
    l = {
        name = "LSP",
        l = { function() vim.cmd("Lspsaga hover_doc") end, "Hover" },
        a = { function() vim.cmd("Lspsaga code_action") end, "Code Action" },
        r = {
            function() vim.cmd("Lspsaga rename") end, "Rename Symbol",
        },
        o = {
            function() vim.cmd("Lspsaga outline") end, "Toggle Outline",
        },
    },
    -- (e)rror diagnostics
    e = {
        name = "Error Diagnostics",
        L = { function() vim.cmd("Lspsaga show_line_diagnostics") end, "Show Line Diagnostics" },
        e = { function() vim.cmd("Lspsaga show_cursor_diagnostics") end, "Show Cursor Diagnostics" },
        j = { function() vim.cmd("Lspsaga diagnostics_jump_previous") end, "Jump to Previous Diagnostics" },
        k = { function() vim.cmd("Lspsaga diagnostics_jump_next") end, "Jump to Next Diagnostic" },
    },
    -- (d)efinitions
    d = {
        name = "Definitions",
        d = { vim.lsp.buf.definition, "Go to Symbol Definition" },
        t = { vim.lsp.buf.type_definition, "Go to Type Definition" },
        p = { function() vim.cmd("Lspsaga peek_definition") end, "Peek Definition" },
    },
    -- (f)ind
    f = {
        name = "Find",
        f = { telescope_builtin.find_files, "Find Files" },
        g = { telescope_builtin.live_grep, "Live Grep", },
        b = { telescope_builtin.buffers, "Buffers", },
        h = { telescope_builtin.help_tags, "Help Tags", },
        s = { function() vim.cmd("SearchSession") end, "Sessions" },
        l = { telescope_builtin.treesutter, "LSP (Treesitter)" },
    },
    -- (c)onfiguration
    c = {
        name = "Configuration",
        e = {
            function()
                telescope_builtin.find_files({ cwd = vim.env.HOME .. '/.config/nvim/' })
            end,
            "Edit Config Files"
        },
        P = {
            name = "Packer",
            S = { function() vim.cmd("PackerSync") end, "Sync" },
            c = { function() vim.cmd("PackerCompile") end, "Compile" },
            i = { function() vim.cmd("PackerInstall") end, "Install" },
            s = { function() vim.cmd("PackerStatus") end, "Status" },
        },
        M = { function() vim.cmd("Mason") end, "Open Mason" },
        s = {
            function()
                local tmpfile, err = io.open(UPDATE_TMPFILE, "w+")
                assert(tmpfile, { message = err })
                tmpfile:close()
                local exit_msg = "Please restart Neovim to see your changes."
                if vim.g.neovide then
                    vim.cmd("!neovide")
                    local ok, _ = pcall(vim.cmd('qa'))
                    if not ok then error(exit_msg) end
                else
                    error(exit_msg)
                end
            end, "Source $MYVIMRC and Update Packages"
        }
    },
    -- (b)uffers
    -- Note: Bufferline makes these look like tabs in traditional IDEs,
    -- but vim has a separate tabpage concept.
    -- Refer to them as buffers to avoid confusion.
    b = {
        name = "Buffers",
        c = { function() vim.cmd("BufferLinePickClose") end, "Pick-Close Buffer" },
        q = { function() vim.cmd("bp | sp | bn | bd") end, "Close Current Buffer" }, -- http://stackoverflow.com/questions/1444322/ddg#8585343
        p = { function() vim.cmd("BufferLinePick") end, "Pick Buffer" },
        k = { function() vim.cmd("BufferLineCycleNext") end, "Next Buffer", },
        j = { function() vim.cmd("BufferLineCyclePrev") end, "Previous Buffer" },
    },
    -- Quick actions
    w = {
        function() vim.cmd("w") end, "Write Buffer"
    },
    W = {
        function() vim.cmd("wa") end, "Write All Buffers"
    },
    q = {
        function() vim.cmd("q") end, "Close Window"
    },
    Q = {
        function() vim.cmd "qa" end, "Close All Windows (Quit Neovim)"
    },
}

local function toggle_terminal()
    -- open existing terminals or create one
    local terms = require 'toggleterm.terminal'.get_all(false);
    for _, _ in pairs(terms) do return vim.cmd("ToggleTermToggleAll") end
    vim.cmd("ToggleTerm")
end

local mappings = {
    ['<C-k>'] = { function() vim.cmd("BufferLineCycleNext") end, "Previous Buffer" },
    ['<C-j>'] = { function() vim.cmd("BufferLineCyclePrev") end, "Next Buffer" },
    ['<C-b>'] = {
        function()
            vim.cmd('NvimTreeToggle')
            -- Uncomment this if you want VS-Code like tree focus.
            -- Focus NvimTree if already open and not focused, otherwise toggle.
            -- buffer 0 is current buffer
            -- if require 'nvim-tree.utils'.is_nvim_tree_buf(0) then
            --     vim.cmd('NvimTreeClose')
            -- else
            --     vim.cmd('NvimTreeFocus')
            -- end
        end, "Toggle Nvim-Tree"
    },
    ['<C-`>'] = { toggle_terminal, "Toggle Terminal" },
    -- TODO: Make this actually warn.
    ['<C-\\>'] = { function() toggle_terminal(); print("WARNING: This has unexpected side-effects. Use <C-`> instead."); end,
        "ToggleTerm (dep)" }
}

local function split_term()
    local term = require 'toggleterm.terminal'
    local num_terms = 1
    for _, _ in pairs(term.get_all(false)) do
        num_terms = num_terms + 1
    end
    vim.cmd(num_terms .. " ToggleTerm")
end

local terminal_mappings = {
    ['<esc>'] = { "<C-\\><C-n>", "Exit terminal mode" },
    ['<C-`>'] = { function() vim.cmd("ToggleTermToggleAll") end, "Toggle Terminal" },
    ['<C-w>'] = {
        name = "Window actions",
        h = { "<esc><C-w>h", "Goto Left Window" },
        ['<C-h>'] = { "<esc><C-w>h", "which_key_ignore" },
        j = { "<esc><C-w>j", "Goto Below Window" },
        ['<C-j>'] = { "<esc><C-w>h", "which_key_ignore" },
        k = { "<esc><C-w>k", "Goto Above Window" },
        ['<C-k>'] = { "<esc><C-w>k", "which_key_ignore" },
        l = { "<esc><C-w>l", "Goto Right Window" },
        ['<C-l>'] = { "<esc><C-w>l", "which_key_ignore" },
        s = { split_term, "Split Terminal" },
        ['<C-s>'] = { split_term, "which_key_ignore" },
        q = { "<esc><C-w>q", "Close Focused Terminal" },
        ['<C-q>'] = { "<esc><C-w>q", "which_key_ignore" },
    }
}

register(leader_mappings, { prefix = "<leader>" })
register(mappings)
register(terminal_mappings, { mode = "t" })
