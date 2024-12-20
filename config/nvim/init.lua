-- Author: Cesar Gimenes
-- Email: crg@crg.eti.br
-- Description: Neovim configuration file
require "plugins"
require "options"
require "mappings"
require "colors"
require "bookmark"
require "sort"
require "eval"
require "cmdx"

--[[
local status,_ = pcall(vim.cmd, "vim command")
if not status then
    print("vim command failed")
    return
end
]]                  --

local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands
local fn = vim.fn   -- call Vim functions

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
]] --

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
]] --

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
]] --

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


local function safe_format_json_onsave()
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
    return
  end
  vim.notify(
    "Error formatting JSON: please check the file syntax.\nDetails: " .. table.concat(formatted_content, "\n"),
    vim.log.levels.ERROR
  )
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.json',
  callback = function()
    safe_format_json_onsave()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  -- Clear trailing whitespace on save
  pattern = {
    "*.c",
    "*.cpp",
    "*.css",
    "*.go",
    "*.h",
    "*.hpp",
    "*.js",
    "*.json",
    "*.lua",
    "*.m",
    "*.md",
    "*.py",
    "*.rs",
    "*.sh",
    "*.txt",
    "*.vim",
    "*.yaml",
    "*.yml",
  },
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Create a Scratch Buffer. Open a temporary, non-file-backed buffer for jotting down notes or testing code snippets.
vim.api.nvim_set_keymap('n', 'bb', ':enew<CR>', { noremap = true, silent = true })


-- vim.api.nvim_set_keymap("n", "<leader>f", ":lua FormatJavaScript()<CR>", { noremap = true, silent = true })
-- /format javascript files with prettier


vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {
    "*.html",
    "*.js",
  },
  callback = function()
    -- Save the cursor position
    local save_cursor = vim.fn.getpos('.')

    if vim.fn.executable("prettier") ~= 1 then
      print("Prettier não está instalado. Instale-o para formatar JavaScript e HTML.")
      return
    end

    local buf = vim.api.nvim_get_current_buf()
    local start_line = 0
    local end_line = vim.api.nvim_buf_line_count(buf)
    local buf_content = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)
    local content = table.concat(buf_content, '\n')

    -- Exec the prettier command and get the output
    local cmd = "prettier --stdin-filepath " .. vim.fn.shellescape(vim.fn.expand('%')) .. " 2>&1"
    local output = vim.fn.system(cmd, content)
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
      -- Prettier has succeeded, format the buffer
      local formatted = vim.split(output, '\n')
      vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, formatted)

      -- Restore the cursor position
      return
    end

    -- Restore the cursor position
    vim.fn.setpos('.', save_cursor)
    -- Prettier falhou, exibe a mensagem de erro sem alterar o buffer
    vim.notify("Erro ao formatar com Prettier:\n" .. output, vim.log.levels.ERROR)
  end
})

-- Função para copiar o bloco de código delimitado por ```
function Copy_code_block()
  if vim.bo.filetype ~= "markdown" then
    return
  end

  -- Obtém o buffer atual e as informações do cursor
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]

  -- Obtém todas as linhas do buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Função para verificar se uma linha começa com ```
  local function is_backtick_line(line)
    return string.match(line, "^```") ~= nil
  end

  -- Encontra a linha de início do bloco de código
  local start_line = nil
  for i = current_line, 1, -1 do
    if is_backtick_line(lines[i]) then
      start_line = i
      break
    end
  end

  if not start_line then
    vim.notify("Bloco de código de início ``` não encontrado.", vim.log.levels.ERROR)
    return
  end

  -- Encontra a linha de término do bloco de código
  local end_line = nil
  for i = current_line, #lines do
    if is_backtick_line(lines[i]) then
      end_line = i
      break
    end
  end

  if not end_line then
    vim.notify("Bloco de código de término ``` não encontrado.", vim.log.levels.ERROR)
    return
  end

  if end_line == start_line then
    vim.notify("Bloco de código não fechado corretamente.", vim.log.levels.ERROR)
    return
  end

  -- Extrai as linhas do código entre os ```
  local code_lines = {}
  for i = start_line + 1, end_line - 1 do
    table.insert(code_lines, lines[i])
  end

  -- Junta as linhas em uma única string
  local code = table.concat(code_lines, "\n")

  -- Copia para a área de transferência
  vim.fn.setreg("+", code)

  vim.notify("Bloco de código copiado para a área de transferência.", vim.log.levels.INFO)
end

-- Mapeia a função para <Leader>c no modo normal if filetypes == markdown
vim.api.nvim_set_keymap("n", "<Leader>c", ":lua Copy_code_block()<CR>", { noremap = true, silent = true })
