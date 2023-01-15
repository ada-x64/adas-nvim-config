-- other files
require('globals');
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
    callback = function(_cwd, _scope, _changed_window)
        vim.cmd("NvimTreeOpen " .. vim.cmd('pwd'))
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

-- TODO: Add autocmd to redirect :help to :Help
-- will that work with Telescope?
-- help -- https://gist.github.com/wbthomason/5e249439b5fc5738cb4b44419e302f68
vim.cmd([[
" This function originates from https://www.reddit.com/r/neovim/comments/eq1xpt/how_open_help_in_floating_windows/; it isn't mine
function! CreateCenteredFloatingWindow() abort
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let l:textbuf = nvim_create_buf(v:false, v:true)
    call nvim_open_win(l:textbuf, v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
    return l:textbuf
endfunction

function! FloatingWindowHelp(query) abort
    let l:buf = CreateCenteredFloatingWindow()
    call nvim_set_current_buf(l:buf)
    setlocal filetype=help
    setlocal buftype=help
    execute 'help ' . a:query
endfunction

command! -complete=help -nargs=? Help call FloatingWindowHelp(<q-args>)
]])

-- keymaps must come after all plugin setup
require('keymaps')

-- check for updates
local f = io.open(UPDATE_TMPFILE, 'r')
if f then
    vim.cmd("PackerInstall")
    io.close(f)
    os.remove(UPDATE_TMPFILE)
    print("Updated!")
end
