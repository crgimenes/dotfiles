function Mark_point()
  local home = os.getenv("HOME")
  local file_marks = home .. "/marks.txt"

  local file = vim.fn.expand('%:p') -- caminho completo
  local line = vim.fn.line('.')     -- número da linha atual

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
    local file_path, line_number = string.match(
        line, "^(.-)%s+%+(%d+)$")
    vim.cmd('edit ' .. file_path)
    vim.cmd('normal gg')
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

vim.api.nvim_set_keymap(
  'n', '<leader>o', ':lua Open_marks()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n', '<leader>m', ':lua Mark_point()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_command(
  'command! Clearmarks lua Clear_marks()'
)

