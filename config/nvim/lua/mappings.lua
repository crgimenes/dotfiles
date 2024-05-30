local api = vim.api -- nvim api
local cmd = vim.cmd -- execute Vim commands
local fn = vim.fn -- call Vim functions

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

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true })
api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true })

api.nvim_set_keymap("n", "<Tab>", "gt", { noremap = true })
api.nvim_set_keymap("n", "<S-Tab>", "gT", { noremap = true })
api.nvim_set_keymap("n", "<S-t>", ":tabnew<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>.", ":lcd %:p:h<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/" <CR>', { noremap = true, silent = true })

api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>h", ":History:<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>e", ":Files<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>l", ":FZF -m --no-sort<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>y", ":History:<CR>", { noremap = true, silent = true })



api.nvim_set_keymap("n", "<leader>rv", ":Lines<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>rf", ":Files<CR>", { noremap = true, silent = true })
api.nvim_set_keymap("n", "<leader>rg", ":Rg<CR>", { noremap = true, silent = true })
--[[

:Lines
:BLines
:Rg
:Ag

--]] --



api.nvim_set_keymap("n", "YY", '"+y<CR>', { noremap = true })
api.nvim_set_keymap("n", "<leader>p", '"+gP<CR>', { noremap = true })
api.nvim_set_keymap("n", "XX", '"+x<CR>', { noremap = true })

if fn.has('macunix') == 1 then
    -- pbcopy for OSX copy/paste
    api.nvim_set_keymap("v", "<C-x>", ":!pbcopy<CR>", { noremap = true })
    api.nvim_set_keymap("v", "<C-c>", ":w !pbcopy<CR><CR>", { noremap = true })
end

api.nvim_set_keymap("n", "<leader>z", ":bp<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>q", ":bp<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>x", ":bn<CR>", { noremap = true })
api.nvim_set_keymap("n", "<leader>w", ":bn<CR>", { noremap = true })
api.nvim_set_keymap("n", "ff", ":bn<cr>", { noremap = true })
api.nvim_set_keymap("n", "fq", ":bd<cr>", { noremap = true })
-- Close buffer
api.nvim_set_keymap("n", "<leader>c", ":bd<CR>", { noremap = true })

-- Clean search (highlight)
api.nvim_set_keymap("n", "<leader><space>", ":noh<CR>", { noremap = true })

-- text navegate
api.nvim_set_keymap("n", "<Up>", "gk", { noremap = true })
api.nvim_set_keymap("n", "<Down>", "gj", { noremap = true })
-- api.nvim_set_keymap("i", "<Up>", "<C-o>gk", { noremap = true })
-- api.nvim_set_keymap("i", "<Down>", "<C-o>gj", { noremap = true })


-- CoC popup menus
-- https://github.com/neoclide/coc.nvim/blob/release/Readme.md
local keyset = vim.keymap.set
keyset('i', '<tab>', 'coc#pum#visible() ? coc#pum#confirm() : "<tab>"', { expr = true })
keyset('i', '<cr>', 'coc#pum#visible() ? coc#pum#confirm() : "<cr>"', { expr = true })

-- CoC jump to definition
keyset('n', '<C-]>', '<Plug>(coc-definition)', { silent = true, noremap = true })
-- keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true, noremap = true })
keyset('n', '<cr>', '<Plug>(coc-definition)', { silent = true, noremap = true })
-- back to previous location with backspace or <C-o>
keyset('n', '<backspace>', '<C-o>', { silent = true, noremap = true })

-- CoC prevents <cr> from working in insert mode
keyset('i', '<cr>', 'coc#pum#visible() ? coc#pum#confirm() : "<cr>"', { expr = true })


-- cnoremap <expr><Up> pumvisible() ? "\<Left>" : "\<Up>"
-- cnoremap <expr><Down> pumvisible() ? "\<Right>" : "\<Down>"



-- abbreviatons
api.nvim_exec("iabbrev qq qualquer", false)
api.nvim_exec("iabbrev vc você", false)
api.nvim_exec("iabbrev crg@ crg@crg.eti.br", false)

-- add undo break points
-- api.nvim_set_keymap("i", '"', '<c-g>u', { noremap = true })
-- api.nvim_set_keymap("i", '<cr>', '<cr><c-g>u', { noremap = true })

-- Copilot
cmd("cnoreabbrev dcp Copilot disable")
cmd("cnoreabbrev ecp Copilot enable")

--cmd("cnoreabbrev rf Files")
--cmd("cnoreabbrev rv Rg")


-- remove trailing whitespaces
cmd("command! FixWhitespace :%s/\\s\\+$//e")



local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>rv', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})





