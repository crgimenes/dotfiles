-- Author: Cesar Gimenes
-- Email: crg@crg.eti.br
-- Description: Neovim configuration file

--[[
local status,_ = pcall(vim.cmd, "vim command")
if not status then
    print("vim command failed")
    return
end
]] --

require "plugins"
require "options"

local g = vim.g -- global variables
local fn = vim.fn -- call Vim functions
local api = vim.api -- nvim api
local wo = vim.wo -- window-scoped options
local cmd = vim.cmd -- execute Vim commands
local o = vim.o -- global options


-- automatic file type detection and indentation according to file type
-- o.filetype_plugin = true
-- o.indent_on = true


-- load local configurations
local local_vim = fn.expand("~/.config/nvim/local.vim")
if fn.filereadable(local_vim) == 1 then
    cmd("source " .. local_vim)
end

-- calendarfile autocmd
local calendarfile = api.nvim_create_augroup("calendarfile", { clear = true })
api.nvim_create_autocmd("BufRead,BufNewFile", {
    command = "setlocal noexpandtab",
    group = calendarfile,
    pattern = "calendar",
})
api.nvim_create_autocmd("BufRead,BufNewFile", {
    command = "setlocal noexpandtab",
    group = calendarfile,
    pattern = "calendarfile",
})

-- let vimplug_exists = expand('~/.config/nvim/autoload/plug.vim')
-- local vimplug_exists = fn.expand('~/.config/nvim/autoload/plug.vim')

-- Required:

-- Colors

-- highlight Visual  guifg=#000000 guibg=#FFFFFF gui=none
-- api.nvim_set_hl(0, 'Normal', { fg = "#ffffff", bg = "#333333" })
-- api.nvim_set_hl(0, 'Comment', { fg = "#111111", bold = true })
-- api.nvim_set_hl(0, 'Error', { fg = "#ffffff", undercurl = true })
-- api.nvim_set_hl(0, 'Cursor', { reverse = true })
api.nvim_set_hl(0, "Visual", { reverse = true, bold = true })

cmd("highlight Pmenu ctermbg=lightgrey guibg=lightgrey")
cmd("highlight PmenuSel ctermbg=white guibg=white")
-- highlight PmenuSbar ctermbg=gray guibg=gray


-- cnoremap <expr><Up> pumvisible() ? "\<Left>" : "\<Up>"
-- cnoremap <expr><Down> pumvisible() ? "\<Right>" : "\<Down>"



-- session management
g.session_directory = fn.expand('~/.config/nvim/session')
g.session_autoload = 'no'
g.session_autosave = 'no'
g.session_command_aliases = 1

g.syntax_on = true
o.ruler = true


g.no_buffers_menu = 1
o.mousemodel = "popup"
o.t_Co = 256
o.guioptions = "egmrti"
o.gfn = "Monospace 10"

g.CSApprox_loaded = 1

g.indentLine_enabled = 1
g.indentLine_concealcursor = 0
g.indentLine_char = '┆'
g.indentLine_faster = 1
--------------------------------

o.laststatus = 2
o.modeline = true
o.modelines = 10
o.title = true
o.titleold = "Terminal"
o.titlestring = "%F"
o.statusline = "%F%m%r%h%w%=(%{&ff}/%Y) (line %l/%L, col %c)"
o.autoread = true

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

if fn.exists("*fugitive#statusline") == 1 then
    o.statusline = o.statusline .. fn['fugitive#statusline']()
end

-- No one is really happy until you have this shortcuts
local mappings = {
    ["W!"] = "w!",
    ["Q!"] = "q!",
    ["Qall!"] = "qall!",
    ["Wq"] = "wq",
    ["Wa"] = "wa",
    ["wQ"] = "wq",
    ["WQ"] = "wq",
    ["W"] = "w",
    ["Q"] = "q",
    ["Qall"] = "qall",
}

for key, value in pairs(mappings) do
    cmd("cnoreabbrev " .. key .. " " .. value)
end

-- Copilot
cmd("cnoreabbrev dcp Copilot disable")
cmd("cnoreabbrev ecp Copilot enable")

--cmd("cnoreabbrev rf Files")
--cmd("cnoreabbrev rv Rg")


-- remove trailing whitespaces
cmd("command! FixWhitespace :%s/\\s\\+$//e")

-- Remember cursor position
cmd([[
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
]])


if not fn.exists('setupWrapping') then
    function setupWrapping()
        wo.wrap = true
        wo.wrapmargin = 2
        wo.textwidth = 79
    end
end

-- nasm
api.nvim_create_autocmd("BufRead,BufNewFile", {
    command = "set filetype=nasm",
    group = calendarfile,
    pattern = "*.asm",
})


api.nvim_set_keymap("n", "<Tab>", "gt", { noremap = true })
api.nvim_set_keymap("n", "<S-Tab>", "gT", { noremap = true })
api.nvim_set_keymap("n", "<S-t>", ":tabnew<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>.", ":lcd %:p:h<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/" <CR>', { noremap = true, silent = true })


-- FZF
-- g.fzf_action = {
--    ['enter'] = 'tab split',
--    ['ctrl-x'] = 'split',
--    ['ctrl-v'] = 'vsplit',
--    ['ctrl-t'] = 'tabnew',
-- }

o.wildmode = "list:longest,list:full"
o.wildignore = "*.o,*.obj,.git,*.rbc,*.pyc,__pycache__"
o.wildignorecase = true
o.wildmenu = true
o.wildoptions = "pum"
-- wildmenu colors
-- cmd("highlight WildMenu ctermfg=White ctermbg=Black")
api.nvim_set_hl(0, "WildMenu", { ctermfg = "White", ctermbg = "Black" })
api.nvim_set_hl(0, "WildMenuSel", { ctermfg = "Black", ctermbg = "White" })



api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>h", ":History:<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>e", ":Files<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>l", ":FZF -m --no-sort<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>y", ":History:<CR>", { noremap = true, silent = true })



api.nvim_set_keymap("n", "<leader>rv", ":Lines<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>rf", ":Files<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>rg", ":Rg<CR>", { noremap = true, silent = true })
--[[

:Lines
:BLines
:Rg
:Ag

--]] --


api.nvim_set_keymap("n", "YY", '"+y<CR>', { noremap = true })
api.nvim_set_keymap("n", "<leader>p", '"+gP<CR>', { noremap = true })
api.nvim_set_keymap("n", "XX", '"+x<CR>', { noremap = true })

if fn.has('macunix') == 1 then
    -- pbcopy for OSX copy/paste
    api.nvim_set_keymap("v", "<C-x>", ":!pbcopy<CR>", { noremap = true })
    api.nvim_set_keymap("v", "<C-c>", ":w !pbcopy<CR><CR>", { noremap = true })
end

api.nvim_set_keymap("n", "<leader>z", ":bp<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>q", ":bp<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>x", ":bn<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>w", ":bn<CR>", { noremap = true })
api.nvim_set_keymap("n", "ff", ":bn<cr>", { noremap = true })
-- Close buffer
api.nvim_set_keymap("n", "<leader>c", ":bd<CR>", { noremap = true })

-- Clean search (highlight)
api.nvim_set_keymap("n", "<leader><space>", ":noh<CR>", { noremap = true })

-- text navegate
api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true })
api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true })
-- api.nvim_set_keymap("i", "<Up>", "<C-o>gk", { noremap = true })
-- api.nvim_set_keymap("i", "<Down>", "<C-o>gj", { noremap = true })


-- CoC popup menus
-- https://github.com/neoclide/coc.nvim/blob/release/Readme.md
local keyset = vim.keymap.set
keyset('i', '<tab>', 'coc#pum#visible() ? coc#pum#confirm() : "<tab>"', { expr = true })
keyset('i', '<cr>', 'coc#pum#visible() ? coc#pum#confirm() : "<cr>"', { expr = true })


-- abbreviatons
api.nvim_exec("iabbrev qq qualquer", false)
api.nvim_exec("iabbrev vc você", false)
api.nvim_exec("iabbrev crg@ crg@crg.eti.br", false)

-- add undo break points
-- api.nvim_set_keymap("i", '"', '<c-g>u', { noremap = true })
-- api.nvim_set_keymap("i", '<cr>', '<cr><c-g>u', { noremap = true })



cmd([[

if remote_clipboard_enabled 

  " It Sends yanked text to the client 
  " machine's clipboard. Requires terminal 
  " emulator with OSC52 support
  augroup remote_clipboard
      au!
      function Copy()
          let l:c64 = system("b64", @")
          let l:s = "\e]52;c;" . l:c64 . "\x07"
          call chansend(v:stderr, l:s)
      endfunction
      autocmd TextYankPost * call Copy()
  augroup END

endif
]])
