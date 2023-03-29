local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local status, packer = pcall(require, 'packer')
if not status then
    print('Packer not found')
    return
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    -- My plugins here

    use('nvim-lualine/lualine.nvim') -- statusline
   -- use('w0rp/ale')
    use { 'neoclide/coc.nvim', branch = 'release' }
    use('rhysd/vim-clang-format')
    use('junegunn/fzf')
    use('junegunn/fzf.vim')
    use('buoto/gotests-vim')
    use('vimwiki/vimwiki')
    use('Shougo/vimproc.vim')
    use('chriskempson/base16-vim')
    use('fatih/vim-go')
    use('github/copilot.vim')


    -- use {'nvim-treesitter/nvim-treesitter'}
    -- use {'nvim-orgmode/orgmode', config = function()
    --     require('orgmode').setup{}
    -- end
    -- }
    -- use("/Users/cesar/Projects/liprog.nvim")


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
