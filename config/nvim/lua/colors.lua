local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands

-- cmd("highlight WildMenu ctermfg=White ctermbg=Black")
api.nvim_set_hl(0, "WildMenu", { ctermfg = "White", ctermbg = "Black" })
api.nvim_set_hl(0, "WildMenuSel", { ctermfg = "Black", ctermbg = "White" })

-- highlight Visual  guifg=#000000 guibg=#FFFFFF gui=none
-- api.nvim_set_hl(0, 'Normal', { fg = "#ffffff", bg = "#333333" })
-- api.nvim_set_hl(0, 'Comment', { fg = "#111111", bold = true })
-- api.nvim_set_hl(0, 'Error', { fg = "#ffffff", undercurl = true })
-- api.nvim_set_hl(0, 'Cursor', { reverse = true })
api.nvim_set_hl(0, "Visual", { reverse = true, bold = true })

cmd("highlight Pmenu ctermbg=lightgrey guibg=lightgrey")
cmd("highlight PmenuSel ctermbg=white guibg=white")
-- highlight PmenuSbar ctermbg=gray guibg=gray