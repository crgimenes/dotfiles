function Cmdx()
  local start_line, start_col, end_line, end_col
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  start_line = start_pos[2] - 1
  start_col = start_pos[3] - 1
  end_line = end_pos[2] - 1
  end_col = end_pos[3]

  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

  if #lines == 0 then
    print("Nenhum texto selecionado")
    return
  end

  -- Imprimir o texto selecionado
  print(table.concat(lines, "\n"))
end

vim.api.nvim_create_user_command('Cmdx', function(opts)
  Cmdx()
end, { range = true, nargs = 0 })

