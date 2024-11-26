function sort_lines()
  -- Obter a posição inicial e final da seleção
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Converter a posição para o índice da linha

  -- Ajuste start_pos porque as linhas no Lua começam do 0
  local start_line = start_pos[2] - 1
  -- Não precisa ajustar end_line
  local end_line = end_pos[2]

  -- Obter as linhas selecionadas
  local lines = vim.api.nvim_buf_get_lines(
      0,
      start_line,
      end_line,
      false
  )

  -- Ordenar as linhas
  table.sort(lines)

  -- Substituir as linhas originais
  vim.api.nvim_buf_set_lines(
    0,
    start_line,
    end_line,
    false,
    lines
  )
end

function sort_and_uniq_lines()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(
    0,
    start_line,
    end_line,
    false
  )

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

  vim.api.nvim_buf_set_lines(
    0,
    start_line,
    end_line,
    false,
    uniq_lines
  )
end

vim.api.nvim_set_keymap(
    'v',
    '<Leader>s',
    ':lua sort_lines()<CR>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'v',
    '<Leader>u',
    ':lua sort_and_uniq_lines()<CR>',
    { noremap = true, silent = true }
)

