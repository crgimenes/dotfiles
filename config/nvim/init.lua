local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands
local g = vim.g -- global variables
local o = vim.o -- global options
local opt = vim.opt -- global/buffer/windows-scoped options
local fn = vim.fn -- call Vim functions
local call = vim.call -- call Vim functions

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
local local_vim = "~/.config/nvim/local.vim"
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

--[[
*****************************************************************************
Vim-PLug core
*****************************************************************************
--]]
-- let vimplug_exists = expand('~/.config/nvim/autoload/plug.vim')
local vimplug_exists = fn.expand('~/.config/nvim/autoload/plug.vim')
g.vim_bootstrap_langs = "c,go,html,javascript,rust"
g.vim_bootstrap_editor = "nvim" -- nvim or vim

-- Required:
fn.call("plug#begin", { "~/.config/nvim/plugged" })
local Plug = fn['plug#']

--[[
*****************************************************************************
Plug install packages
*****************************************************************************
--]]
Plug('itchyny/lightline.vim')
Plug('w0rp/ale')
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('rhysd/vim-clang-format')
Plug('junegunn/fzf', { ['do'] = fn['fzf#install'] })
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
        path = '~/Documents/wiki/',
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
Copilot
--]]
Plug('github/copilot.vim')
g.copilot_enabled = 0

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

api.nvim_command("autocmd BufEnter * lua set_clang_format_keymap()")

--[[
end plugin config
--]]
call('plug#end')

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
g.session_directory = '~/.config/nvim/session'
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

-------------------------------------------------------------------------------
cmd([[



    " Copilot
cnoreabbrev dcp Copilot disable
cnoreabbrev ecp Copilot enable

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" terminal emulation
nnoremap <silent> <leader>sh :terminal<CR>

"*****************************************************************************
"" Commands
"*****************************************************************************
" remove trailing whitespaces
command! FixWhitespace :%s/\s\+$//e

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
    function s:setupWrapping()
        set wrap
        set wm=2
        set textwidth=79
    endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
    autocmd!
    autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
    autocmd!
    autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

"" nasm
autocmd BufNewFile,BufRead *.asm set filetype=nasm

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" session management
nnoremap <leader>so :OpenSession<Space>
nnoremap <leader>ss :SaveSession<Space>
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>
"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

" ale
let g:ale_linters = {}

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
    " pbcopy for OSX copy/paste
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>
noremap ff :bn<cr>
"noremap gp :bp<cr>
"noremap gd :bd<cr>


"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" c
autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab


" go
" vim-go
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
    autocmd!
    if v:version > 703 || v:version == 703 && has('patch598')
        autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
    endif
augroup END

augroup go

    au!
    au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

    au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
    au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>db <Plug>(go-doc-browser)

    au FileType go nmap <leader>r  <Plug>(go-run)
    au FileType go nmap <leader>t  <Plug>(go-test)
    au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
    au FileType go nmap <Leader>i <Plug>(go-info)
    au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
    au FileType go nmap <C-g> :GoDecls<cr>
    au FileType go nmap <leader>dr :GoDeclsDir<cr>
    au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
    au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
    au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END

" ale
:call extend(g:ale_linters, {
            \"go": ['golint', 'go vet'], })


" html
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab


" javascript
let g:javascript_enable_domhtmlcss = 1

" vim-javascript
augroup vimrc-javascript
    autocmd!
    autocmd FileType javascript setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
augroup END


" rust
" Vim racer
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)


" text navegate
map  <buffer> <silent> <Up>   gk
map  <buffer> <silent> <Down> gj
"inoremap <buffer> <silent> <Up>   <C-o>gk
"inoremap <buffer> <silent> <Down> <C-o>gj

" rust
let g:rustfmt_autosave = 1
let g:racer_experimental_completer = 1
"au FileType rust set makeprg=cargo\ build\ -j\ 4
"au FileType rust nmap <leader>t :!cargo test<cr>
"au FileType rust nmap <leader>r :!RUST_BACKTRACE=1 cargo run<cr>
"au FileType rust nmap <leader>c :term cargo build -j 4<cr>
"au FileType rust nmap gd <Plug>(rust-def)
"au FileType rust nmap gs <Plug>(rust-def-split)
"au FileType rust nmap gx <Plug>(rust-def-vertical)
"au FileType rust nmap <leader>gd <Plug>(rust-doc)

set mouse=a

" CoC popup menus
inoremap <expr> <tab> coc#pum#visible() ? coc#pum#confirm() : "\<tab>"


"test leader
nnoremap <leader>uu :let view=winsaveview()<cr>viw~<esc>:call winrestview(view)<cr>:echo "~"<cr>

nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"abbreviatons
iabbrev qq qualquer
iabbrev vc você
iabbrev crg@ crg@crg.eti.br

"add undo break points
inoremap " "<c-g>u
inoremap <cr> <cr><c-g>u

"undo
set undofile
set undodir=~/.localtmp/undodir
set undolevels=1000
set undoreload=100000

"set wrap
set wrap linebreak

set noswapfile
set nobackup

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
