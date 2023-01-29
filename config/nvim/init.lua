-- Author: Cesar Gimenes
-- Email: crg@crg.eti.br
-- Description: Neovim configuration file

-- Options
local o = vim.o -- global options
local opt = vim.opt -- global/buffer/windows-scoped options



local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands
local g = vim.g -- global variables
local fn = vim.fn -- call Vim functions
local call = vim.call -- call Vim functions
local wo = vim.wo -- window-scoped options

-- g.mapleader = ','


-- remote clipboard default disabled
g.remote_clipboard_enabled = 0

-- python3
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python3"

-- find files recursively in subdirectories
-- set path+=**
o.path = o.path .. "**"


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
local plugged = fn.expand("~/.config/nvim/plugged")
fn.call("plug#begin", { plugged })
local Plug = fn['plug#']

--[[
*****************************************************************************
Plug install packages
*****************************************************************************
--]]
Plug('nvim-lualine/lualine.nvim') -- statusline
Plug('w0rp/ale')
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('rhysd/vim-clang-format')
Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')
Plug('buoto/gotests-vim')
Plug('vimwiki/vimwiki')
Plug('Shougo/vimproc.vim', { ['do'] = 'make' })
Plug('chriskempson/base16-vim')
Plug('fatih/vim-go', { ['do'] = ':GoInstallBinaries' })


-- HTML
Plug('hail2u/vim-css3-syntax')
Plug('gorodinskiy/vim-coloresque')
Plug('tpope/vim-haml')
Plug('mattn/emmet-vim')

-- Javascript
Plug 'jelera/vim-javascript-syntax'

Plug('github/copilot.vim')
g.copilot_enabled = 0

call('plug#end')



-- Rust
-- Plug('racer-rust/vim-racer')
-- Plug('rust-lang/rust.vim')

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



-- vimwiki
g.vineiki_url_maxsave = 0
g.vimwiki_auto_header = 1
g.vimwiki_global_ext = 0
g.vimwiki_autowriteall = 1
g.vimwiki_markdown_link_ext = 1
g.vimwiki_automatic_nested_syntaxes = 1
g.vimwiki_links_space_char = '_'
g.vimwiki_key_mappings = {
    all_maps = 0,
}
g.vimwiki_listsyms = ' ○◐●✓'
g.vimwiki_key_mappings = {
    all_maps = 1,
    global = 1,
    headers = 1,
    text_objs = 1,
    table_format = 0,
    table_mappings = 0,
    lists = 0,
    links = 1,
    html = 1,
    mouse = 1,
}
g.vimwiki_list = {
    {
        path = fn.expand('~/Documents/wiki/'),
        syntax = 'markdown',
        ext = '.md',
        auto_toc = 1,
        auto_tags = 1,
        auto_generate_tags = 1,
        auto_diary_index = 1
    }
}
g.vimwiki_diary_months = {
    ['1'] = 'Janeiro',
    ['2'] = 'Fevereiro',
    ['3'] = 'Março',
    ['4'] = 'Abril',
    ['5'] = 'Maio',
    ['6'] = 'Junho',
    ['7'] = 'Julho',
    ['8'] = 'Agosto',
    ['9'] = 'Setembro',
    ['10'] = 'Outubro',
    ['11'] = 'Novembro',
    ['12'] = 'Dezembro',
}
-- vimwiki key mappings
api.nvim_set_keymap('n', '<C-S-t>', "<Plug>VimwikiToggleListItem", { noremap = true, silent = true });

--[[
Golang
--]]

g.go_def_mode = 'gopls'
g.go_info_mode = 'gopls'
-- g.deoplete#enable_at_startup = 1
-- g.deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

--[[
C/C++
--]]

g['clang_format#style_options'] = {
    ['AccessModifierOffset'] = -4,
    ['AllowShortIfStatementsOnASingleLine'] = 'true',
    ['AlwaysBreakTemplateDeclarations'] = 'true',
    ['Standard'] = 'C++11'
}

function set_clang_format_keymap()
    local filetype = api.nvim_buf_get_option(0, 'filetype')
    if filetype == 'c' or
        filetype == 'cpp' or
        filetype == 'objc' or
        filetype == 'h' then
        api.nvim_buf_set_keymap(0, "n", "<Leader>cf", "<cmd>ClangFormat<CR>", {
            noremap = true,
            silent = true
        })
        api.nvim_buf_set_keymap(0, "v", "<Leader>cf", "<cmd>ClangFormat<CR>", {
            noremap = true,
            silent = true
        })
        api.nvim_buf_set_keymap(0, "n", "<Leader>C", "<cmd>ClangFormatAutoToggle<CR>", {
            noremap = true,
            silent = true
        })
        api.nvim_command("ClangFormatAutoEnable")
    end
end

local clang_format = api.nvim_create_augroup("clang_format", { clear = true })
api.nvim_create_autocmd("BufEnter", {
    command = "lua set_clang_format_keymap()",
    pattern = "*",
    group = clang_format,
})




-- lualine setup
require('lualine').setup({
    options = {
        theme = '16color',
        icons_enabled = false,
    },
})

-- automatic file type detection and indentation according to file type
o.filetype_plugin = true
o.indent_on = true

o.encoding = 'utf-8'
o.fileencoding = 'utf-8'
o.fileencodings = 'utf-8'
o.backspace = 'indent,eol,start'
o.tabstop = 4
o.softtabstop = 0
o.shiftwidth = 4
o.expandtab = true
o.hidden = true

-- search
o.hlsearch = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true

-- file format
o.fileformats = 'unix,dos,mac'

-- shell
-- o.shell = os.getenv("SHELL")
o.shell = '/bin/zsh'

-- session management
g.session_directory = fn.expand('~/.config/nvim/session')
g.session_autoload = 'no'
g.session_autosave = 'no'
g.session_command_aliases = 1

g.syntax_on = true
o.ruler = true
o.number = true


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


-- Copy/Paste/Cut
o.clipboard = 'unnamed,unnamedplus'
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


g.go_list_type = "quickfix"
g.go_fmt_command = "goimports"
g.go_fmt_fail_silently = 1

g.go_highlight_types = 1
g.go_highlight_fields = 1
g.go_highlight_functions = 1
g.go_highlight_methods = 1
g.go_highlight_operators = 1
g.go_highlight_build_constraints = 1
g.go_highlight_structs = 1
g.go_highlight_generate_tags = 1
g.go_highlight_space_tab_error = 0
g.go_highlight_array_whitespace_error = 0
g.go_highlight_trailing_whitespace_error = 0
g.go_highlight_extra_types = 1

-- text navegate
api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true })
api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true })
-- api.nvim_set_keymap("i", "<Up>", "<C-o>gk", { noremap = true })
-- api.nvim_set_keymap("i", "<Down>", "<C-o>gj", { noremap = true })


-- CoC popup menus
-- https://github.com/neoclide/coc.nvim/blob/release/Readme.md
local keyset = vim.keymap.set
keyset('i', '<tab>', 'coc#pum#visible() ? coc#pum#confirm() : "<tab>"', { expr = true })


-- abbreviatons
api.nvim_exec("iabbrev qq qualquer", false)
api.nvim_exec("iabbrev vc você", false)
api.nvim_exec("iabbrev crg@ crg@crg.eti.br", false)

-- add undo break points
-- api.nvim_set_keymap("i", '"', '<c-g>u', { noremap = true })
-- api.nvim_set_keymap("i", '<cr>', '<cr><c-g>u', { noremap = true })

-- undo
o.undofile = true
o.undodir = fn.expand("~/.localtmp/undodir")
o.undolevels = 1000
o.undoreload = 100000

-- set wrap
o.wrap = 'linebreak'

o.noswapfile = true
o.nobackup = true


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
