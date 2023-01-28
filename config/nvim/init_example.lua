Autocmd = vim.api.nvim_create_autocmd
Augroup = vim.api.nvim_create_augroup
Cmd = vim.api.nvim_command
Map = vim.api.nvim_set_keymap

Nmap = function(key, cmd, conf)
    Map('n', key, cmd, conf)
end
Lualine_extra = {
    navic_component = nil,
    lsp_clients = nil,
    current_time = function()
        return os.date("%H:%M")
    end
}

local run_commands = {
    rust = { type = "rust", command = "mold -run cargo run --release" }
}

require("impatient")
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("packer").startup(function(use)

    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'

    -- Colorschemes ---------------------------------------------------------------------
    use {
        'EdenEast/nightfox.nvim',
        config = function()
            require("nightfox").setup {
                options = {
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        strings = "italic"
                    }
                },
                groups = {
                    all = {
                        LspInlayHint = { fg = "palette.fg3", bg = "palette.bg2" }
                    }
                }
            }
        end
    } -- nightfox
    use {'srcery-colors/srcery-vim', as = 'srcery'}
    use 'savq/melange'
    use 'sainnhe/everforest'
    use 'nyoom-engineering/oxocarbon.nvim'
    use 'arzg/vim-colors-xcode'
    use 'ayu-theme/ayu-vim'
    use 'tssm/fairyfloss.vim'
    use 'mhartington/oceanic-next'
    use 'ellisonleao/gruvbox.nvim'
    use 'fenetikm/falcon'
    use 'rktjmp/lush.nvim'
    use 'folke/lsp-colors.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }

    -- Specific Languages ---------------------------------------------------------------------
    use 'habamax/vim-godot'
    use 'MaxMEllon/vim-jsx-pretty'
    use {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup { }
        end
    }
    use 'dag/vim-fish'

    use {
        'lervag/vimtex',
        config = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_ignore_filters = {'Underfull', 'Overfull'}
            vim.g.vimtex_view_method = "zathura"
            vim.g.Tex_IgnoreLevel = 8
        end
    } -- vimtex, see below as well

    use 'neovimhaskell/haskell-vim'
    use 'pangloss/vim-javascript'
    use 'plasticboy/vim-markdown'
    use {'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }}

    -- General tools -----------------------------------------------------------------------------
    use 'nvim-lua/plenary.nvim'
    use 'MunifTanjim/nui.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            Nmap('-qw', ':Telescope diagnostics<CR>', {noremap = true, silent = true})
            Nmap('-qq', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
            Nmap('-ff', ':Telescope find_files<CR>', {noremap = true, silent = true})
            Nmap('<C-b>', ':Telescope buffers<CR>', {noremap = true, silent = true})
            Nmap('<C-g>', ':Telescope live_grep<CR>', {noremap = true, silent = true})
        end
    } -- telescope, see below as well
    use {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {}
                }
            }

            require("telescope").load_extension("ui-select")
        end
    } -- telescope-ui-select
    use 'AndrewRadev/bufferize.vim'
    use 'dbakker/vim-projectroot'
    use 'godlygeek/tabular'
    use {
        'mbbill/undotree',
        config = function()
            Nmap('-u', ':UndotreeToggle<CR>', {silent = true})
        end
    } -- undotree
    use {
        'tpope/vim-commentary',
        config = function()
            Nmap(';', 'gccj', {silent = true})
            Map('v', ';', 'gc', {silent = true})
        end
    } -- commentary
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            local treesDoes physics in Godot use global coordinates always ? For example, if I set the Transform.origin of a RigidBody3D, it is w.r.t. the parent node, but if I need to set its LinearVelocity do I need to use global coordinates?itter = require("nvim-treesitter.configs")
            treesitter.setup {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    } -- treesitter
    use 'nvim-treesitter/playground'
    use {
        'dcampos/nvim-snippy',
        config = function()
            require('snippy').setup({
                mappings = {
                    is = {
                        ['<C-Space>'] = 'expand_or_advance',
                        ['<S-Tab>'] = 'previous',
                    },
                },
            })
        end
    } -- snippy
    use 'dcampos/cmp-snippy'
    use {
        'petertriho/nvim-scrollbar',
        config = function()
            require("scrollbar").setup()
        end
    }
    use {
        'filipdutescu/renamer.nvim',
        branch = 'master',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require("renamer").setup {}
            Nmap('-re', '<cmd>lua require("renamer").rename()<CR>', {noremap = true, silent = true})
        end
    } -- renamer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    adaptive_size = true,
                    mappings = {
                        list = {
                            { key = "u", action = "dir_up" },
                            { key = "-", action = ""},
                        },
                    },
                },
                update_cwd = true
            }
            Nmap('<leader>d', ':ProjectRootExe NvimTreeToggle<CR>', {silent = true})
        end
    } -- nvim-tree
    use {
        'romgrk/barbar.nvim',
        config = function()
            require"bufferline".setup {
                auto_hide = true,
                insert_at_end = true
            }

            for i = 1,10 do
                Map('n', '<M-' .. i .. '>', '<Cmd>BufferGoto ' .. i .. '<CR>', {noremap = true, silent = true})
            end

            Nmap('<C-q>', '<Cmd>BufferClose<CR>', {noremap = true})
            Nmap('<C-p><C-p>', '<Cmd>BufferPick<CR>', {noremap = true})
            Nmap('<C-<><C-<>', '<Cmd>BufferMovePrevious<CR>', {noremap = true})
            Nmap('<C->><C->>', '<Cmd>BufferMoveNext<CR>', {noremap = true})

        end
    } --barbar
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require("lualine").setup {
                options = {
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {'packer', 'NvimTree'},
                        winbar = {'packer', 'NvimTree'}
                    }
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff' },
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },

                winbar = {
                    lualine_a = { Lualine_extra.navic_component },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = { 'diagnostics' },
                    lualine_y = { Lualine_extra.lsp_clients },
                    lualine_z = { Lualine_extra.current_time }
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                }
            }
        end
    } -- lualine 
    use {
        'voldikss/vim-floaterm',
        config = function()
            vim.g.floaterm_autoclose = 0
            vim.g.run_command = "echo 'No command setup.'"
            Nmap('<C-t>', '<cmd>:FloatermToggle<CR>', {noremap = true, silent = true})
        end
    }

    -- LSP related stuff ---------------------------------------------------------------
    use 'williamboman/nvim-lsp-installer'
    use 'neovim/nvim-lspconfig'
    
    -- use {
    --     'lewis6991/hover.nvim',
    --     config = function()
    --         require("hover").setup {
    --             init = function()
    --                 require("hover.providers.lsp")
    --             end,

    --             preview_opts = {
    --                 border = nil
    --             },

    --             preview_window = false,

    --             title = true
    --         }
    --         Nmap("<C-b>", ":lua require('hover').hover()<CR>", {desc = "hover.nvim"})
    --     end
    -- }

    use 'simrat39/rust-tools.nvim'
    use {
        'kosayoda/nvim-lightbulb',
        requires = 'antoinemadec/FixCursorHold.nvim',
    }
    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
    use {
        'j-hui/fidget.nvim',
        config = function()
            require("fidget").setup {}
        end
    }
    use {
        'lvimuser/lsp-inlayhints.nvim',
        config = function()
            require("lsp-inlayhints").setup()
        end
    }
    -- Nvim-cmp, see below for settings -------
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-omni'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
end)


Cmd("filetype plugin on")
Cmd("filetype indent plugin on")

vim.g.mapleader = " "
-- vim.o.omnifunc="syntaxcomplete#Complete"
vim.o.ruler = true
vim.o.completeopt = "noinsert"
vim.o.compatible = false
vim.o.ff = 'unix'
vim.o.backspace="indent,eol,start"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- vim.o.relativenumber = true
vim.wo.cursorline = true
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.foldenable = false
vim.o.foldmethod = "manual"
vim.o.mouse = "a"
vim.o.number = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.wildmenu = true
vim.o.wrap = false
vim.o.background = "dark"

----- Colorscheme machinery ----------------------------------

vim.g.everforest_background = 'hard'
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1

Cmd("colorscheme gruvbox")

local colorschemes = {
    oxocarbon = { mode = "dark" },
    gruvbox = { mode = "dark" },
    dayfox = { },
    carbonfox = { },
    terafox = { },
    everforest = { mode = "dark" },
}

local menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

Colorscheme_Menu = menu({
    position = "50%",
    border = {Does physics in Godot use global coordinates always ? For example, if I set the Transform.origin of a RigidBody3D, it is w.r.t. the parent node, but if I need to set its LinearVelocity do I need to use global coordinates?
        style = "rounded",
        text = {
            top = "Colorscheme",
            top_align = "center"
        },
    },
    win_options = {
        winhighlight = "Normal:Normal"
    },
}, {
    lines = (function()
        local lines = {}
        for k, v in pairs(colorschemes) do
            lines[#lines + 1] = menu.item(k, vim.tbl_deep_extend("force", {cs = k}, v))
        end
        return lines
    end)(),
    min_width = 20,
    keymap = {
        focus_next = { "<Down>" },
        focus_prev = { "<Up>" },
        close = { "<Esc>", "q" },
        submit = { "<CR>" }
    },
    on_close = function()
    end,
    on_change = function(item, _menu)
        Cmd("colorscheme " .. item.cs)
        if item.mode then
            vim.o.background = item.mode
        end
    end,
    on_submit = function(item)
        Cmd("colorscheme " .. item.cs)
    end
})

Nmap("<F9>", ":lua Colorscheme_Menu:mount()<CR>", {noremap = true, silent = true})

Autocmd("BufRead", {
    pattern = "*",
    callback = function()
        vim.cmd([[hi! link Pmenu Normal]])
    end
})

----------------------------------------------------------------


Map('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
Map('i', '<C-c><C-c>', '<Esc>cc', {noremap = true})
Map('n', '<C-c><C-c>', 'cc', {noremap = true})

Nmap('<C-n>', ':noh<CR>', {silent = true})

Nmap('-p', '"+p', {silent = true})
Map('v', '-y', '"+y', {silent = true})
Nmap('--', 'zA', {silent = true})

-- open config
Nmap('-ec', ':tabnew /home/subwave/.config/nvim/init.lua<CR>', {silent = true})
Nmap('-es', ':source /home/subwave/.config/nvim/init.lua<CR>', {silent = true})

Map('i', '<C-s>', '<Esc>:w<CR>', {silent = true})
Map('n', '<C-s>', '<Esc>:w<CR>', {silent = true})

-------------- TeX additional settings -------------------

function TexMode()
    vim.o.wrap = true
    Map('n', '<Down>', 'gj', {silent = true, noremap = true})
    Map('n', '<Up>', 'gk', {silent = true, noremap = true})
    Map('v', '<Down>', 'gj', {silent = true, noremap = true})
    Map('v', '<Up>', 'gk', {silent = true, noremap = true})
    Map('i', '<Down>', '<C-o>gj', {silent = true, noremap = true})
    Map('i', '<Up>', '<C-o>gk', {silent = true, noremap = true})
    Map('i', '<Home>', '<C-o>g<Home>', {silent = true, noremap = true})
    Map('i', '<End>', '<C-o>g<End>', {silent = true, noremap = true})

    Map('n', 'j', 'gj', {silent = true, noremap = true})
    Map('n', 'k', 'gk', {silent = true, noremap = true})
    Map('v', 'j', 'gj', {silent = true, noremap = true})
    Map('v', 'k', 'gk', {silent = true, noremap = true})

    Nmap('<C-f>', ':call SyncTexForward()<CR>', {noremap = true, silent = true})
    print("TeX-mode enabled.")
end

function TexModeOff()
    vim.o.wrap = false
    Map('n', '<Down>', '<Down>', {silent = true, noremap = true})
    Map('n', '<Up>', '<Up>', {silent = true, noremap = true})
    Map('v', '<Down>', '<Down>', {silent = true, noremap = true})
    Map('v', '<Up>', '<Up>', {silent = true, noremap = true})
    Map('i', '<Down>', '<Down>', {silent = true, noremap = true})
    Map('i', '<Up>', '<Up>', {silent = true, noremap = true})
    Map('i', '<Home>', '<Home>', {silent = true, noremap = true})
    Map('i', '<End>', '<End>', {silent = true, noremap = true})

    Map('n', 'j', 'j', {silent = true, noremap = true})
    Map('n', 'k', 'k', {silent = true, noremap = true})
    Map('v', 'j', 'j', {silent = true, noremap = true})
    Map('v', 'k', 'k', {silent = true, noremap = true})

    print("TeX-mode disabled.")
end

Nmap('-tt', ':VimtexCompile<CR>', {noremap = true})
Nmap('-tv', ':VimtexView<CR>', {noremap = true})

Nmap('-oth', ':lua TexModeOff()<CR>', {silent = true})
Nmap('-tex', ':lua TexMode()<CR>', {silent = true})

Autocmd("FileType", {
        pattern = 'tex',
        callback = TexMode
    })


vim.cmd[[
function! SyncTexForward()
    let execstr = "silent !zathura --synctex-forward ".line(".").":".col(".").":%:p %:p:r.pdf &"
    exec execstr
    endfunction
    ]]

--------------- VIMTEX ends -----------------


-------------- LSP --------------------------

local navic = require("nvim-navic")

local navic_on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

Lualine_extra.navic_component = function()
    if navic.is_available() then
        return navic.get_location({})
    else
        return "  "
    end
end

Lualine_extra.lsp_clients = function ()
    local name = vim.lsp.get_active_clients({bufnr = vim.fn.bufnr()})[1].name
    if name then
        return " "..name
    else
        return ""
    end
end

----- Add on_attach triggers below
local on_attach = function(client, bufnr)
    navic_on_attach(client, bufnr)
    require("lsp-inlayhints").on_attach(client, bufnr)
end

local cmp = require("cmp")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col > 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 20
cmp.setup {
    formatting = {
        format = function(entry, vim_item)
            -- print(vim_item)
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            end
            vim_item.menu = ""  --- dont display additional information
            return vim_item
        end,
    },
    sources = cmp.config.sources {
        { name = "omni"},
        { name = "nvim_lsp"},
        { name = "path" },
        { name = "buffer", keyword_length = 4},
        { name = "snippy" }
    }
}

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
        snippet = {
            expand = function(args)
                require 'snippy'.expand_snippet(args.body)
            end
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        mapping = {
            ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
            ['<Down>'] = cmp.mapping.select_next_item(select_opts),
            ['<Tab>'] = cmp.mapping(function(fallback)
                -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
                if cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        cmp.confirm()
                    end
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, {"i", "s"})
    }
})

cmp.setup.cmdline(':', {
        completion = {
            autocomplete = false
        }
    })

Autocmd({"CmdLineEnter"}, {
        pattern = "*",
        command = "lua require('cmp').setup({enabled = false})"
    })

Autocmd({"CmdLineLeave"}, {
        pattern = "*",
        command = "lua require('cmp').setup({enabled = true})"
    })


local capabilities = require("cmp_nvim_lsp").default_capabilities()

------------------ Begin LSP servers definitions -----------------------

require('nvim-lsp-installer').setup {
    automatic_installation = true
}

local lua_runtime_path = vim.split(package.path .. ";" .. package.cpath, ";")
local cwd = os.getenv("PWD")

require("rust-tools").setup{
    server = {
        cmd = { "/home/subwave/.cargo/bin/rust-analyzer" },
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
                inlayHints = { locationLinks = false },
            }
        },
        capabilities = capabilities,
        on_attach = on_attach
    }
}

require("rust-tools").inlay_hints.disable()

Library = {}

local path = vim.split(package.path, ";")

-- this is the ONLY correct way to setup your path
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local function add_lib(lib)
    for _, p in pairs(vim.fn.expand(lib, false, true)) do
        p = vim.loop.fs_realpath(p)
        if p then 
            Library[p] = true
        end
    end
end

-- add runtime
add_lib("$VIMRUNTIME")

-- add your config
add_lib("~/.config/nvim")

-- add plugins
-- if you're not using packer, then you might need to change the paths below
add_lib("~/.local/share/nvim/site/pack/packer/opt/*")
add_lib("~/.local/share/nvim/site/pack/packer/start/*")

local sumneko_opts = {
    settings = {
        Lua = {
            runtime = {
                version = "Lua 5.4",
                path = lua_runtime_path
            },
            workspace = {
                -- library = vim.api.nvim_get_runtime_file("", true)
                checkThirdParty = false,
                library = Library,
                maxPreload = 2000,
                preloadFileSize = 50000,
            },
            diagnostics = {
                globals = { 'vim', 'love' }
            },
            telemetry = {
                enable = false,
            }
        }
    },
    on_attach = on_attach,
    capabilities = capabilities,
}
require("lspconfig").sumneko_lua.setup(sumneko_opts)

require'lspconfig'.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require("lspconfig").omnisharp.setup {
    on_attach = on_attach,
    capabilities = capabilities
}Does physics in Godot use global coordinates always ? For example, if I set the Transform.origin of a RigidBody3D, it is w.r.t. the parent node, but if I need to set its LinearVelocity do I need to use global coordinates?

require('lspconfig').gdscript.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

-- require('lspconfig').jedi_language_server.setup {
--     cmd = {"/home/subwave/soft/conda/bin/jedi-language-server"},
--     on_attach = navic_on_attach
-- }
--
-- require("lspconfig").jedi_language_server.setup(coq.lsp_ensure_capabilities{})

-------------- Metals config -------------------

-- local metals_config = require("metals").bare_config()

-- -- Example of settings
-- metals_config.settings = {
--   showImplicitArguments = true,
--   excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
-- }
-- metals_config.init_options.statusBarProvider = "on"
-- metals_config.capabilities = capabilities

-- local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

-- metals_config.on_attach = function(client, bufnr)
--     navic_on_attach(client, bufnr)
-- end

-- vim.api.nvim_create_autocmd("FileType", {
--   -- NOTE: You may or may not want java included here. You will need it if you
--   -- want basic Java support but it may also conflict if you are using
--   -- something like nvim-jdtls which also works on a java filetype autocmd.
--   pattern = { "scala", "sbt", "java" },
--   callback = function()
--     require("metals").initialize_or_attach(metals_config)
--   end,
--   group = nvim_metals_group,
-- })

----------Lsp Servers end --------------
---------- Telescope additional menu -----------------------
local menu = require("nui.menu")

local telescope_actions = {
    { text = "Jump to definition", cmd = "lsp_definitions" },
    { text = "Show calls to this", cmd = "lsp_incoming_calls" },
    { text = "Show references to this", cmd = "lsp_references" },
    { text = "Show workspace issues", cmd = "diagnostics" },
    { text = "Live grep", cmd = "live_grep" },
}

Telescope_Menu = menu({
    position = "50%",
    border = {
        style = "rounded",
        text = {
            top = "Telescope actions",
            top_align = "center"
        },
    },
    win_options = {
        winhighlight = "Normal:Normal"
    },
}, {
    lines = (function()
        local lines = {}
        for k, v in ipairs(telescope_actions) do
            lines[#lines + 1] = menu.item("" .. k .. ". " .. v.text, v)
        end
        return lines
    end)(),
    min_width = 40,
    keymap = {
        focus_next = { "<Down>" },
        focus_prev = { "<Up>" },
        close = { "<Esc>", "q" },
        submit = { "<CR>" }
    },
    on_close = function()
    end,
    on_submit = function(item)
        print(item.cmd)
        Cmd(":Telescope " .. item.cmd)
    end
})

Nmap("<F2>", ":lua Telescope_Menu:mount()<CR>", {noremap = true, silent = true})

-------- Setup run commands for Floatterm -------------


for _, v in pairs(run_commands) do
    Autocmd("FileType", {
        pattern = v.type,
        callback = function()
            vim.g.run_command = v.command
            Nmap('<F5>', '<cmd>:FloatermNew ' .. vim.g.run_command .. ' <CR>', {noremap = true, silent = true})
        end
    })
end


--- Change styles for autocomplete and documentation popups ---------
-- Trick to set max width of popup, copied from https://neovim.discourse.group/t/lsp-hover-float-window-too-wide/3276
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single'
    opts.max_width= opts.max_width or 80
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local _border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = _border
    }
    )

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = _border
    }
    )

vim.diagnostic.config{
    float={border=_border}
}

Nmap("<C-h>", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true})
Nmap("-qf", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true})

Nmap('-qe', '<cmd>lua vim.diagnostic.open_float()<CR>', {noremap = true, silent = true})
Nmap('<C-e>', ':TroubleToggle document_diagnostics<CR>', {noremap = true, silent = true})

----Stuff for italics----------------------------------------
vim.cmd[[
    set t_ZH=^[[3m
    set t_ZR=^[[23m
]]

-------------Neovide ----------------------------------------
vim.cmd[[set guifont=JetbrainsMono\ Nerd\ Font:h10]]
vim.g.neovide_fullscreen = 1
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_vfx_particle_density = 40.0
vim.g.neovide_cursor_animation_length = 0.04
vim.g.neovide_cursor_trail_size = 0.1

------ Legacy init.vim in base64 after zlib -----------
-- import zlib, base64; initvim = zlib.decompress(base64.b64decode(<string below>))
--
vim.g.legacy = "eJydWXt3EzcW/9+fQphynJQ4A5Ttdt04Gwih5ZwEWAiUnobjlWc0M4pnpEHS+MGe/e77kzRP20C7OYcwui9dXd2nEtIsI0VWJnfnLOHi4HAwG"
    .. "JLXWJNRnNHPn4Mlz8ehzKTSYcpypkctgZaiSAMpWEqzuANfxWsV5FzwnBbH4O+gPpSbkooi0KGSWTan6lj0CRTlIsnkKvBgD3ySMa2piJT8Xao5DZ"
    .. "5kUclFg76UC5oZmThdcymkgU4NlqrPSecU43UooxZrEVCGF0YHLMx4odlxd2tFF8pxm5Ucx1yxFTVh2qBvS8GSUohAM1lmj/72Y495lVKzkWXKI+Z"
    .. "kJNKktEUbrfMgplxt4kxq3WOlEcuo0p88n+J5fitXDTbjMSt4BooKXy7ncv1Ty70px8ZeV2C/eueROSycBbhcY5hg0ZdkOmsZlhcgZO6Cxrs/7b0Z"
    .. "uqChY0ypigzPv8RTb5fP59gsKEUkjWKs4wKmkIW3ly6VkqBodExoaVjqcGzJRcjGeiNCw9btKZhaUnffHloLvaTX7MP4qVyPrxnNg2bZIQFPRueBL"
    .. "jJuxoapvHchrVbWC2CVkI2OyH8QJlKNyISMwkzeloqNyH9rlkIxDXV4HggGm/hTepTVUkRsFeiyYMrQ+Z59QpnnTBiqNm0gIAbY6g2cYxnMyzhmin"
    .. "9mX1KzTLjhy3ZPEeUcvstg9SQNeeTVV6YYQXubArjQgQtHe4TaKpZlIzbV1eoF2MccqgvTMR0TMtdJl+Zc4nZoBrRuFWASEYZYCGXo4x4ajOaKCkQ"
    .. "UdFAsY1SzUWf3QtE5VzqFJRE6boNMF6MGn8OLRQ0ea2YM0kc3R20JoNZfJJyamcpuf4LQyu4ZOZrTxYL5OCmUvGWhUVKaFu89EJ6i0+7pAavME9Sm"
    .. "9GJr95ZRtkkYWwTwiBKROKo9KaPa8HAu/T3kVC0iubIZsL0CaJxLw6U3R7u0RA1VSuc0p2tHQnXIeSRDAwfuGExnfLXwptY5TpXybnAuGDdpoFc8N"
    .. "j2T4GDK2h6pN5C4ecHDsWDr1iZXdH11kWWVerd6DcvhulrfLqhN/Fp7PF1Sn5YbfFd1GKpjbjOHdaRnzEraD+kx8mvGhY+J6nv0LQKfPHXXvsIUcA"
    .. "Xld5lDc6bGq5QbpgubChq6V7ngb2GMIpD40vZr3C9x+VyFDx/57UrovaJFBxsxxRarDfzaX0FIM9r6kKtESCSaWwWCrTXowqaeMxH5av4LkgDJGaH"
    .. "EpmZic3M/L4MGbk6SSZ26ZxGLaZmZmRRkSh7uz/27lUBIxVDyycm74pScvJTFaRf4DA67B3zJYrMH/IYnaQMH4iVjEYsIki3p9w7A0TJBmSjI2xrx"
    .. "QnADOCHWvmEe3ekuyHmptFRXcsmio/c8fwPjfcbnv0puXitGvieaZ0hvdwh8iSj2qUS+Pxg1u44Oj3UqV7BtV+hvXFwIXMHRcxmW+hfUWGjb/vzfQ"
    .. "i8ZXTIv9FJqQ8hfExoioyontTYS3MJ5NXIlmdNwURYRV9PzSfBOW+++UjyhAvH/VsZmRRXzPrbi4sfHgacPwB+XKLtILnfItUySjJ2XGXaxSlm5YZ"
    .. "ndcQvFIkVXA+xZMwwG9eFeCGxovNH8tzsrTuV8uCt3YBq/uNAhvOJ8fHOKX+K0OkkmwUNCX3MytmTZ9NFgYFVRJToC9yWkzefU8HnGHCCOp6Xg60H"
    .. "j/t2cP7NqzlBMy2L6ABS80YCtC+VUgJMTUpT5kmsr8+CQ/JMMb5xaQzQE+Lym89OhtRauyWwKRnyVJTCDVcAmCGuXKfY1dF1vffe8+ugw+orb5Xcs"
    .. "9suJQi+kcdNh6lZpVi38NYsynzOFy0Arh1zgl4MWM/B3ZqPCJr/KWitFC/dpW6Gk5L59HlTYWGbQiDa2xDJnJpXRNKeipJmny2Wp2ZT6hc5dibAH8"
    .. "XLpHGm7mD722BQlZcUjk1YA2BktEog8Gu7YMjjQits9RTkY+Ot7a1spmPyZT16VFeFz17DgdHQSjten+CVPR40P1pZ+hoEBjlegh9PMOgSPid5otL"
    .. "8HKOaGkfv3fh0dklMkw7+7CCVN/CSuQ51GKMnAMFh+P0FmE5qlEBGP7RadoYq0Q0DrjfVEMWuFIBkDsMVb03WDemvPDvnOzvUcMHMn+LIMr5Qbnhx"
    .. "olttBaFYgRYiZNpuMTR9uyW6Jt3ftYPqIV751eInOYZuHuqFvG1qPPjNbu3ZYNmVrz3ownDkKmPKPHx4+PiKPHhyRfzz4uMVZE9fuzjCIqDkaNr1v"
    .. "j52j1bb80h0Ll0l89j4l4xWZrE7O37hsdu67frRSpNT2d38U2GL9mSRheDtY7gB39hBkImRa7+IiHtPuXMJs95EHBc1ZhPSit/kKMrxfbG0w3gC48"
    .. "XEHBGoMuhZYdEiGg9p9XFs09eF+xGR2pKG+2VFrTD4/2YaxkEwQ64KtSJBKDLG6TJDOkA02wTGSfMwTV5UCjjpvu1B/qoFocnQj6hqSkL7I/ftKrv"
    .. "T04QNie3JP36lhbH2FW+tUMJf87EJs9S/J7RbY9jrJwgGX+2mX+2j5dl90jsRUMfB+I+Uw21y/wi41zi+2CC5EhPpUEdjFoK/47c5RFjvnuN05QkP"
    .. "TqYi3PeU7iEWje68B2LH7qzjumL6qPPuM7//bcwH2194r6HAs93PsXETLwb/FUV3CF83v7d47fL+VJpdPri8+PH31YbfBHtoqZEV9/EhObPd/eolC"
    .. "tD63FQod7IVYNpnNIZ7K9cw+1azzxQyT1ZKzFTKdTSQlinC2cdl5ix4NY7iI+do2S1uKvX9xBc329f2I8TbSxsaQyXv32GJrKcLOxVYHv6zx76GRD"
    .. "zyvBUAzVJ+ly8VDp/qwQsEvZi8SKyP6jSphR3oydQa+Gb1DRlFxmWWj4+GNGB5X4FfLfVBdsJDHHMkpTDFeoiU3sk/xuywxFqHttO0zRn8W9fFXXL"
    .. "ss7DulI4JhC5pGhGrymSl53Ke+TjG9kZX9hdrJYjcFKBYDgNZU94nPuaHWKci943t3W/o+0TNZosciLpuiywJVteVgx1aXtu+FLX+q8jt6thgOML1"
    .. "iIpOT9GEHLgu7sZ42LuHfy2bOa3wfB0GjT0UUW9Bomy70d63gaTKxpcNSi6XaIXQCE/QXimZu4erEyD/efZ260rHqpuqfG8s+HqNxx3WRMyh4c1er"
    .. "cHIG/smZbV8nZ6i6f0p0HS9dkaOuc8dx7bzPpcIwFL11bbXz4q2ZuA4YBLvejRoXM/3KBKFk4ieduvr40OmTSZP2yVyyrMt4f5NnXNuGHF1HsbE+O"
    .. "2fwbI74kjGJOrSDwXqnUkZkOIv2VNDIIaIvvP/+iZ/B9sn/fecOeZiYbejZGXm0C717l/ywC/3uO/I4MW1rl+lipqE3sl0481NJ1Ml3Fh1xiiCxj2"
    .. "h6xsJUzvy8Uz1v9OWf+IYG3f7kUhe/SqSW6sr3042561cIiF/YecK1atbDvsr10Um3ne6FbS6/SvuHo31t0zqS+bfpf25kV/nzq9SjnvQux7Y3lmT"
    .. "yrnqw9/P5XqqITF77V9E3UpqLNSMvL948u/46E83J5Gn9pE1y+wefhOm9pGxOJvculjRzWNeajhkjkwYkdkE4fOP06F3JxgdVNeQNV9nYRs3wiJwN"
    .. "D09C5YzV0hdkYl3pbDjVJWZQbkrDDjq8BcUnAkTIMbpWm4WGh0dkhPZnad8p8tMRVvZfMnLSi5747/+6eCwKhfZAbb61UafdeslWz3lWt7nu/FwUp"
    .. "dGofxXQqpFNYvvs51AHQwzUxD5DkD+sHVE/wYjcnX20rx1HZGj/WfxwW6p9SMcJK8EYqL1c1PrhoM7mNhLJ8NwJRMx6hJuhawqvkJ3VwVgNBcNjK6"
    .. "ohcVuyNQut1Ryt39JP2r3uayuPXF9XubWxTOVv22nwBE0p5db3PsGpYOjy9FyGl1wb0kkszm8Gg+pZ04VW1bodtM/x9tkbLdehfQjzL3JX1GR0/py"
    .. "vndbNk2VnQRAYlYpH+HwD2eT747z78uXmQ20UInd674bc0434i5fP6olPlcI+7xbUpPenfrSyj9GB/XOS+0OUZlE18vaahG/NdLWav7x74d7z7Msk"
    .. "WJZzYmbL+bSR6NqR51zRG3KFAdv1JIP/AXhD5bM="


