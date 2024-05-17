local fn = vim.fn -- call Vim functions
local opt = vim.opt -- global/buffer/windows-scoped options
local o = vim.o -- global options
local g = vim.g -- global variables
local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands

-- opt.relativenumber = true
opt.number = true

-- opt.cursorline = true
-- opt.cursorcolumn = true
-- opt.colorcolumn = '80'

cmd("cnoreabbrev ern set relativenumber")
cmd("cnoreabbrev drn set norelativenumber")

-- troggle cursorline and cursorcolumn
function _G.TroggleCursorLineAndCursorColumn()
    if opt.cursorline:get() then
        opt.cursorline = false
        opt.cursorcolumn = false
        cmd("highlight CursorLine guibg=none")
    else
        opt.cursorline = true
        opt.cursorcolumn = true
        cmd("highlight CursorLine guibg=#1c1c1c")
    end
end

-- creade command to troggle cursorline and cursorcolumn
cmd("command! TroggleCursorLineAndCursorColumn lua TroggleCursorLineAndCursorColumn()")



-- set cursorline colors
cmd("highlight CursorLine guibg=#1c1c1c")
cmd("highlight CursorColumn guibg=#1c1c1c")
cmd("highlight ColorColumn guibg=#1c1c1c")

opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.fileencodings = 'utf-8'
opt.backspace = 'indent,eol,start'
opt.tabstop = 4
opt.softtabstop = 0
opt.shiftwidth = 4
opt.expandtab = true
opt.hidden = true
opt.autoindent = true

-- search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- file format
opt.fileformats = 'unix,dos,mac'

-- shell
-- o.shell = os.getenv("SHELL")
opt.shell = '/bin/zsh'

-- colors
opt.termguicolors = true
opt.background = "dark"

-- SignColumn
-- vim.o.signcolumn = 'auto' -- this is what you seem to be using.
-- vim.o.signcolumn = 3 -- will use 3 columns. 
-- vim.o.signcolumn = 'number' -- will display signs in the number column.
opt.signcolumn = "yes"
opt.signcolumn = "number"
-- highlight clear SignColumn
-- cmd("highlight SignColumn guibg=none")
cmd("highlight SignColumn guibg=#1c1c1c")

-- Copy/Paste/Cut
opt.clipboard = 'unnamed,unnamedplus'
-- opt. clipboard: append ("unnamedplus")

-- split
opt.splitbelow = true
opt.splitright = true

-- keywords
opt.iskeyword:append("-") -- treat dash separated words as a word text object

-- undo
opt.undofile = true
opt.undodir = fn.expand("~/.localtmp/undodir")
opt.undolevels = 1000
opt.undoreload = 100000

-- set wrap
opt.wrap = true
opt.linebreak = true


-- global options
-- o.noswapfile = true
-- o.nobackup = true

-- find files recursively in subdirectories
-- set path+=**
o.path = o.path .. "**"


o.laststatus = 2
o.modeline = true
o.modelines = 10
o.title = true
o.titleold = "Terminal"
o.titlestring = "%F"
o.statusline = "%F%m%r%h%w%=(%{&ff}/%Y) (line %l/%L, col %c)"
o.autoread = true


if fn.exists("*fugitive#statusline") == 1 then
    o.statusline = o.statusline .. fn['fugitive#statusline']()
end

o.wildmode = "list:longest,list:full"
o.wildignore = "*.o,*.obj,.git,*.rbc,*.pyc,__pycache__"
o.wildignorecase = true
o.wildmenu = true
o.wildoptions = "pum"
-- wildmenu colors

-- automatic file type detection and indentation according to file type
-- o.filetype_plugin = true
-- o.indent_on = true


if not fn.exists('setupWrapping') then
    function setupWrapping()
        local wo = vim.wo -- window-scoped options

        wo.wrap = true
        wo.wrapmargin = 2
        wo.textwidth = 79
    end
end


-- global variables

-- session management
g.session_directory = fn.expand('~/.config/nvim/session')
g.session_autoload = 'no'
g.session_autosave = 'no'
g.session_command_aliases = 1

g.syntax_on = true
o.ruler = true


g.no_buffers_menu = 1
o.mousemodel = "popup"
-- o.t_Co = 256
-- o.guioptions = "egmrti"
-- o.gfn = "Monospace 10"

g.CSApprox_loaded = 1

g.indentLine_enabled = 1
g.indentLine_concealcursor = 0
g.indentLine_char = '┆'
g.indentLine_faster = 1


-- g.mapleader = ','
g.mapleader = " "
-- g.copilot_enabled = 0

-- remote clipboard default disabled
-- if $SSH_CLIENT is set, enable remote clipboard
g.remote_clipboard_enabled = 0
if os.getenv("SSH_CLIENT") ~= nil then
    g.remote_clipboard_enabled = 1
end

-- python3
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python3"

-- o.concealcursor = ''
-- vimwiki
g.vimwiki_url_maxsave = 0
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

-- Golang

g.go_def_mode = 'gopls'
g.go_info_mode = 'gopls'

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

-- let g:go_template_autocreate = 0
g.go_template_autocreate = 0

-- C/C++

g['clang_format#style_options'] = {
    ['AccessModifierOffset'] = -4,
    ['AllowShortIfStatementsOnASingleLine'] = 'true',
    ['AlwaysBreakTemplateDeclarations'] = 'true',
    ['Standard'] = 'C++11'
}


g.tags='tags;/'

-- g.coc_global_extensions = {'coc-clangd'}
g.coc_global_extensions = {'coc-ccls', 'coc-clangd'}

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
        theme = 'dracula-nvim',
        icons_enabled = false,
    },
})

-- https://github.com/Mofiqul/dracula.nvim
local dracula = require("dracula")
dracula.setup({
  colors = {
    bg = "#000000",
    black = "#000000",
    visual = "#000000",
    nontext = "#000000"
  },
  transparent_bg = true,
  lualine_bg_color = "#000000",
  italic_comment = true
})

