-- Author: Cesar Gimenes
-- Email: crg@crg.eti.br
-- Description: Neovim configuration file
require "plugins"
require "options"
require "mappings"
require "colors"

--[[
local status,_ = pcall(vim.cmd, "vim command")
if not status then
    print("vim command failed")
    return
end
]] --

local fn = vim.fn -- call Vim functions
local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands

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

-- Remember cursor position
cmd([[
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
]])


-- nasm
api.nvim_create_autocmd("BufRead,BufNewFile", {
    command = "set filetype=nasm",
    group = calendarfile,
    pattern = "*.asm",
})


cmd([[
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

autocmd FileType c,cpp,objc ClangFormatAutoEnable

autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab

let g:ale_completion_enabled = 1
let g:ale_cpp_ccls_init_options = {
\   'cache': {
\       'directory': '"/tmp/ccls'
\   }
\ }




" Example keybindings
"nn <silent> <M-d> :ALEGoToDefinition<cr>
"nn <silent> <M-r> :ALEFindReferences<cr>
"nn <silent> <M-a> :ALESymbolSearch<cr>
"nn <silent> <M-h> :ALEHover<cr>

nn <silent> <c-[> :ALEGoToDefinition<cr>

]])


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

P = function(v)
    print(vim.inspect(v))
    return v
end
