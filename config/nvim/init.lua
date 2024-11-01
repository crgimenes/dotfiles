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

-- vim.o.termguicolors = false

P = function(v)
    print(vim.inspect(v))
    return v
end

-----------------------------------------------------

function sort_lines()
    -- Obter a posição inicial e final da seleção
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Converter a posição para o índice da linha
    local start_line = start_pos[2] - 1  -- Ajuste porque as linhas no Lua começam do 0
    local end_line = end_pos[2]          -- Não precisa de ajuste, o fim é exclusivo

    -- Obter as linhas selecionadas
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

    -- Ordenar as linhas
    table.sort(lines)

    -- Substituir as linhas originais
    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, lines)
end

function sort_and_uniq_lines()
    -- Obter a posição inicial e final da seleção
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Converter a posição para o índice da linha
    local start_line = start_pos[2] - 1  -- Ajuste porque as linhas no Lua começam do 0
    local end_line = end_pos[2]          -- Não precisa de ajuste, o fim é exclusivo

    -- Obter as linhas selecionadas
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)

    -- Ordenar as linhas
    table.sort(lines)

    -- Remover linhas duplicadas
    local uniq_lines = {}
    local last_line = nil
    for _, line in ipairs(lines) do
        if line ~= last_line then
            table.insert(uniq_lines, line)
            last_line = line
        end
    end

    -- Substituir as linhas originais
    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, uniq_lines)
end

vim.api.nvim_set_keymap('v', '<Leader>s', ':lua sort_lines()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>u', ':lua sort_and_uniq_lines()<CR>', { noremap = true, silent = true })


cmd([[
" Use `[e` and `]e` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
]])

vim.api.nvim_exec([[
  au SwapExists * let v:swapchoice = "o" | echohl WarningMsg echo "The file is already open, entering read-only mode." | echohl None
  au FocusGained,BufEnter * checktime
  au FileChangedShellPost * echohl WarningMsg | echo "File changed. Buffer reloaded." | echohl None
]], false)


-- close buffer
-- nnoremap <leader>q :enew<bar>bd #<CR>
-- nnoremap <leader>q :bp <bar> bd <bar> e# <bar> bd#<CR>
cmd([[
nnoremap <leader>q :bp <bar> bd <bar> e# <bar> bd#<CR>
]])


--[[
-- POC, function to get the current word under the cursor and passe to neoframe client as parameter.
--]]


vim.api.nvim_set_keymap('n', '<F5>', ':lua WordLookup()<CR>', { noremap = true, silent = true })

function WordLookup()
  local word = vim.fn.expand('<cword>')
  local c = "echo " .. word

  local handle = io.popen(c, 'r')
  if handle then
    local result = handle:read("*a")
    handle:close()
    vim.notify(result, vim.log.levels.INFO)
    return
  end
  vim.notify("Error running command " .. c .. " " .. word, vim.log.levels.ERROR)
end


-- Terminal Settings
vim.cmd([[
  augroup TerminalSettings
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
  augroup END
]])

-- Automatic Insert Mode
vim.cmd([[
  augroup TerminalInsertMode
    autocmd!
    autocmd TermOpen * startinsert
  augroup END
]])

--[[
vim.api.nvim_create_user_command("Rv", function(args)
  local output = vim.fn.systemlist("rv " .. args.args)
  if #output > 0 then
    vim.cmd("edit " .. output[1])
  end
end, { nargs = 1 })
]]--

function Mark_point()
    local home = os.getenv("HOME")
    local file_marks = home .. "/marks.txt"

    local file = vim.fn.expand('%:p')  -- caminho completo
    local line = vim.fn.line('.')      -- número da linha atual

    local mark = file .. " +" .. line

    local file_handle = io.open(file_marks, "a")
    if file_handle then
        file_handle:write(mark .. "\n")
        file_handle:close()
        print("Marked: " .. mark)
        return
    end
    print("Erro ao abrir o arquivo de marcação: " .. file_marks)
end

function Open_mark(marks_file)
    local file = io.open(marks_file, "r")
    if not file then
        -- print("Erro ao abrir o arquivo de marcação: " .. marks_file)
        return
    end

    for line in file:lines() do
        local file_path, line_number = string.match(line, "^(.-)%s+%+(%d+)$")
        vim.cmd('edit ' .. file_path)
        vim.cmd('normal ' .. line_number .. 'G')
    end
    file:close()
end

function Open_marks()
    local path = os.getenv("HOME")
    local marks_file = path .. "/marks.txt"
    Open_mark(marks_file)

    path = vim.fn.getcwd()
    marks_file = path .. "/marks.txt"
    Open_mark(marks_file)
end

function Clear_marks()
    local path = os.getenv("HOME")
    local marks_file = path .. "/marks.txt"
    os.remove(marks_file)

    path = vim.fn.getcwd()
    marks_file = path .. "/marks.txt"
    os.remove(marks_file)
end


vim.api.nvim_set_keymap('n', '<leader>o', ':lua Open_marks()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':lua Mark_point()<CR>', { noremap = true, silent = true })

vim.api.nvim_command('command! Clearmarks lua Clear_marks()')

-- buffers
vim.api.nvim_set_keymap('n', '<leader>bd', ':bp|bd #<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bl', ':ls<CR>', { noremap = true, silent = true })

function Clean_buffers()
    local buffers = vim.api.nvim_list_bufs()
    for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and not vim.api.nvim_buf_get_option(buf, 'modified') then
            vim.api.nvim_buf_delete(buf, {})
        end
    end
    print("Buffers não utilizados foram limpos.")
end

vim.api.nvim_set_keymap('n', '<leader>bc', ':lua Clean_buffers()<CR>', { noremap = true, silent = true })


local function SafeFormatJsonOnSave()
  if vim.fn.executable('jq') == 0 then
    vim.notify("The 'jq' utility is not available on the system.", vim.log.levels.ERROR)
    return
  end

  local view = vim.fn.winsaveview()
  local formatted_content = vim.fn.systemlist('jq .', vim.fn.getline(1, '$'))

  if vim.v.shell_error == 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_content)
    vim.bo.modified = false
    vim.fn.winrestview(view)
  else
    vim.notify(
      "Error formatting JSON: please check the file syntax.\nDetails: " .. table.concat(formatted_content, "\n"),
      vim.log.levels.ERROR
    )
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'json' then
      SafeFormatJsonOnSave()
    end
  end,
})

