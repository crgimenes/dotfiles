-- Função para avaliar código Lua e retornar o resultado
function lua_eval(code)
  -- Primeiro, tenta avaliar como uma expressão
  local func, load_err = load("return " .. code, "LuaEval", "t", _G)
  if func then
    local success, result = pcall(func)
    if success then
      return result
    else
      vim.notify("Lua Eval Runtime Error: " .. result, vim.log.levels.ERROR)
      return nil
    end
  end

  -- Se falhar, tenta avaliar como um bloco de instruções
  -- Cria um ambiente personalizado para capturar a saída de print
  local output = {}
  local env = setmetatable({}, { __index = _G })

  env.print = function(...)
    local args = { ... }
    for i, v in ipairs(args) do
      args[i] = tostring(v)
    end
    table.insert(output, table.concat(args, "\t"))
  end

  func, load_err = load(code, "LuaEval", "t", env)
  if not func then
    vim.notify("Lua Eval Load Error: " .. load_err, vim.log.levels.ERROR)
    return nil
  end

  local success, exec_err = pcall(func)
  if not success then
    vim.notify("Lua Eval Runtime Error: " .. exec_err, vim.log.levels.ERROR)
    return nil
  end

  if #output > 0 then
    return table.concat(output, "\n")
  end

  -- Se não houver saída, retorna nil
  return nil
end

-- Função para obter o texto selecionado no modo visual, incluindo colunas
function get_selected_text()
  -- Obtém as posições de início e fim da seleção
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  local buf = vim.api.nvim_get_current_buf()

  if start_line == end_line then
    -- Seleção dentro de uma única linha
    local line = vim.api.nvim_buf_get_lines(buf, start_line - 1, start_line, false)[1]
    return line:sub(start_col, end_col)
  else
    -- Seleção que abrange múltiplas linhas
    local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
    -- Ajusta a primeira e a última linha para considerar as colunas
    lines[1] = lines[1]:sub(start_col)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    return table.concat(lines, "\n")
  end
end

-- Função para substituir a seleção com o resultado da avaliação Lua
function replace_selection_with_eval()
  local selected_text = get_selected_text()
  local result = lua_eval(selected_text)

  if result == nil then
    return
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  local buf = vim.api.nvim_get_current_buf()

  if start_line == end_line then
    -- Substituição dentro de uma única linha
    local line = vim.api.nvim_buf_get_lines(buf, start_line - 1, start_line, false)[1]
    local new_line = line:sub(1, start_col - 1) .. tostring(result) .. line:sub(end_col + 1)
    vim.api.nvim_buf_set_lines(buf, start_line - 1, start_line, false, { new_line })
  else
    -- Substituição que abrange múltiplas linhas
    local first_line = vim.api.nvim_buf_get_lines(buf, start_line - 1, start_line, false)[1]
    local last_line = vim.api.nvim_buf_get_lines(buf, end_line - 1, end_line, false)[1]

    local new_first_line = first_line:sub(1, start_col - 1) .. tostring(result)
    local new_last_line = last_line:sub(end_col + 1)

    -- Substitui as linhas selecionadas com a nova linha combinada
    vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, { new_first_line, new_last_line })
  end
end

-- Função para inserir o resultado da avaliação Lua abaixo da seleção
function insert_eval_below()
  local selected_text = get_selected_text()
  local result = lua_eval(selected_text)

  if result == nil then
    return
  end

  local end_pos = vim.fn.getpos("'>")
  local end_line = end_pos[2]

  -- Insere o resultado na linha abaixo da seleção
  vim.api.nvim_buf_set_lines(0, end_line, end_line, false, { tostring(result) })
end

-- Mapeia <Leader>e no modo visual para substituir a seleção com o resultado da avaliação Lua
vim.api.nvim_set_keymap(
  'v',
  '<Leader>e',
  ':<C-U>lua replace_selection_with_eval()<CR>',
  { noremap = true, silent = true }
)

-- Mapeia <Leader>l no modo visual para inserir o resultado da avaliação Lua abaixo da seleção
vim.api.nvim_set_keymap(
  'v',
  '<Leader>l',
  ':<C-U>lua insert_eval_below()<CR>',
  { noremap = true, silent = true }
)

