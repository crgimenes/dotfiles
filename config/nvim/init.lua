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
--[[
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
]]--

-- Remember cursor position
cmd([[
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
]])


-- nasm
--[[
api.nvim_create_autocmd("BufNewFile,BufRead", {
    command = "set filetype=nasm",
    group = calendarfile,
    pattern = "*.asm",
})
]]--

cmd([[
augroup calendarfile
    autocmd!
    autocmd BufRead,BufNewFile calendar setlocal noexpandtab
    autocmd BufRead,BufNewFile calendarfile setlocal noexpandtab
augroup END

augroup nasm
    autocmd!
    autocmd BufNewFile,BufRead *.asm set filetype=nasm
augroup END

augroup gohtml
    autocmd!
    autocmd BufNewFile,BufRead *.gohtml set filetype=gohtmltmpl
augroup END

]])


cmd([[
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

autocmd FileType c,cpp,objc ClangFormatAutoEnable

autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab

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

vim.o.termguicolors = false

P = function(v)
    print(vim.inspect(v))
    return v
end
