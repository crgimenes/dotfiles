local fn = vim.fn -- call Vim functions
local opt = vim.opt -- global/buffer/windows-scoped options
local o = vim.o -- global options
local g = vim.g -- global variables
local api = vim.api -- nvim api


-- opt.relativenumber = true -- TODO: create a keybinding to toggle this
opt.number = true

opt.cursorline = false -- TODO: create a keybinding to toggle this

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
-- opt.signcolumn = "yes"
-- opt.signcolumn="number"
-- highlight clear SignColumn
local cmd = vim.cmd -- execute Vim commands
cmd("highlight clear SignColumn")

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

-- global options
o.noswapfile = true
o.nobackup = true

-- find files recursively in subdirectories
-- set path+=**
o.path = o.path .. "**"


-- global variables

-- g.mapleader = ','
g.copilot_enabled = 0

-- remote clipboard default disabled
g.remote_clipboard_enabled = 0

-- python3
g.python3_host_skip_check = 1
g.python3_host_prog = "/usr/bin/python3"
g.python_host_prog = "/usr/bin/python3"

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


-- C/C++

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