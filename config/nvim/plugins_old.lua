local fn = vim.fn -- call Vim functions

-- Plugin manager (vim-plug) TODO: use packer.nvim
local plugged = fn.expand("~/.config/nvim/plugged")
fn.call("plug#begin", { plugged })
local Plug = fn['plug#']

Plug('nvim-lualine/lualine.nvim') -- statusline
Plug('w0rp/ale')
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('rhysd/vim-clang-format')
Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')
Plug('buoto/gotests-vim')
Plug('vimwiki/vimwiki')
Plug('Shougo/vimproc.vim', { ['do'] = 'make' })
Plug('chriskempson/base16-vim')
Plug('fatih/vim-go', { ['do'] = ':GoInstallBinaries' })

-- HTML
Plug('hail2u/vim-css3-syntax')
Plug('gorodinskiy/vim-coloresque')
Plug('tpope/vim-haml')
Plug('mattn/emmet-vim')

-- Javascript
Plug 'jelera/vim-javascript-syntax'

Plug('github/copilot.vim')



call('plug#end')
