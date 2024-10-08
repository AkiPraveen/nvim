--   ______   __    __  ______        __    __  __     __  ______  __       __ 
--  /      \ /  |  /  |/      |      /  \  /  |/  |   /  |/      |/  \     /  |
-- /$$$$$$  |$$ | /$$/ $$$$$$/       $$  \ $$ |$$ |   $$ |$$$$$$/ $$  \   /$$ |
-- $$ |__$$ |$$ |/$$/    $$ | ______ $$$  \$$ |$$ |   $$ |  $$ |  $$$  \ /$$$ |
-- $$    $$ |$$  $$<     $$ |/      |$$$$  $$ |$$  \ /$$/   $$ |  $$$$  /$$$$ |
-- $$$$$$$$ |$$$$$  \    $$ |$$$$$$/ $$ $$ $$ | $$  /$$/    $$ |  $$ $$ $$/$$ |
-- $$ |  $$ |$$ |$$  \  _$$ |_       $$ |$$$$ |  $$ $$/    _$$ |_ $$ |$$$/ $$ |
-- $$ |  $$ |$$ | $$  |/ $$   |      $$ | $$$ |   $$$/    / $$   |$$ | $/  $$ |
-- $$/   $$/ $$/   $$/ $$$$$$/       $$/   $$/     $/     $$$$$$/ $$/      $$/                                                                                   

--------------------------------------------------------------------------------
-- AKI NVIM CONFIGURATION
-- Best used with Neovide
--------------------------------------------------------------------------------
-- KEYMAP LEGEND:
--
-- <leader> -> Space
-- <leader>ff -> Find files
-- <leader>fg -> Live grep
-- <leader>fb -> Buffers
-- <leader>fh -> Help tags
-- <leader>ee -> Toggle file explorer
-- <leader>ca -> Code action
-- <leader>aa -> Launch avante
-- <leader>ar -> Refresh avante sidebar
-- gd -> Goto definition (new tab)
-- gpr -> Goto references (preview window)
-- gpd -> Goto definition (preview window)
--------------------------------------------------------------------------------

-- (1) KEY CONFIGURATION

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- copy/paste -> Mac native
vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
vim.keymap.set('n', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.keymap.set('i', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.keymap.set('c', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.keymap.set('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})

vim.keymap.set('n', '<D-c>', '"+y', { noremap = true, silent = true} ) -- Copy
vim.keymap.set('v', '<D-c>', '"+y', { noremap = true, silent = true}) -- Copy

-- Fix pasting
vim.opt.clipboard:append("unnamedplus")
vim.keymap.set('n', '<leader>v', '"+p`[v`]=', { noremap = true, silent = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

-- Tabs -> Spaces
-- Set tab to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Convert tabs to spaces on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\t/  /ge]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Pragmatapro font
-- Best to install another Nerdfont so system will load it as a fallback
vim.o.guifont = "PragmataPro Mono Liga:h18"

-- Lazy NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Line spacing
vim.opt.linespace = 5  -- Increase this number for more spacing

-- Add padding to the left and right
vim.opt.numberwidth = 4      -- Reserve 4 columns for line numbers
vim.opt.signcolumn = "yes:2"  -- Adds one column of width to the right

-- Add padding to the top and bottom
vim.opt.scrolloff = 8         -- Keep 8 lines above and below the cursor

-- Add extra padding on all sides (available since Neovide 0.10.4)
if vim.g.neovide then
  vim.g.neovide_padding_top = 10
end

-- Set the command line height to 1
vim.opt.cmdheight = 1

vim.opt.number = true
vim.opt.relativenumber = true

-- (2) PLUGIN CONFIGURATION (using lazy.nvim)
require("lazy").setup({
  spec = {
    -- Copilot
    { "github/copilot.vim", name = "copilot", lazy = false },
    -- Theme
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
      "Shatur/neovim-ayu",
      lazy = false,
      priority = 1000,
    },
    -- Telescope: File navigation + search
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- Optional: Add any Telescope-specific configuration here
        require('telescope').setup({
        -- Your Telescope configuration options
        })
      end,
    },
    -- nvim tree: Sidebar
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        local nvimtree = require("nvim-tree")

        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- configure nvim-tree
        nvimtree.setup({
          view = {
            width = 35,
            relativenumber = true,
          },
          update_focused_file = {
            enable = true,
          },
          -- change folder arrow icons
          renderer = {
            indent_markers = {
              enable = true,
            },
            icons = {
              glyphs = {
                folder = {
                  arrow_closed = "", -- arrow when folder is closed
                  arrow_open = "", -- arrow when folder is open
                },
              },
            },
          },
          -- disable window_picker for
          -- explorer to work well with
          -- window splits
          actions = {
            open_file = {
              window_picker = {
                enable = false,
              },
            },
          },
          filters = {
            custom = { ".DS_Store" },
          },
          git = {
            ignore = false,
          },
        })

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
        keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
        keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
        keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
      end,
    },

    -- Tree sitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function () 
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },  
          })
      end
    },
    -- LSP (Language server)
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
    },
    -- Git signs
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup({
          signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
          },
        })
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
      config = function()
        require("ibl").setup({
          indent = { char = "⋅" },
          scope = { enabled = false },
        })
      end,
    },
    -- GREETER
    {
      'goolord/alpha-nvim',
      dependencies = { 'echasnovski/mini.icons' },
      config = function()
        local alpha = require('alpha')
        local startify = require('alpha.themes.startify')

        -- Customize the header
        startify.section.header.val = {
          [[                                   ]],
          [[                                   ]],
          [[ Who dares, wins                  ]],
          [[                                   ]],
          [[                                   ]],
        }

        -- Ensure mini.icons is loaded
        require('mini.icons').setup()

        -- Use mini.icons for file icons (optional)
        local function icon(fn)
          local ext = fn:match("^.+(%..+)$")
          return require('mini.icons').get(ext or fn)
        end

        startify.file_button = function(fn, sc, short_fn)
          short_fn = short_fn or fn
          local ico_txt = icon(fn) .. '  '
          local file_button_el = startify.button(sc, ico_txt .. short_fn, '<cmd>e ' .. fn .. '<cr>')
          return file_button_el
        end

        alpha.setup(startify.config)
      end
    },
    -- GOTO previews
    {
      "rmagatti/goto-preview",
      config = function()
        require('goto-preview').setup {
          width = 125; -- Width of the floating window
          height = 25; -- Height of the floating window
          border = {"╭", "─" ,"╮", "│", "╯", "─", "╰", "│"}; -- Border characters of the floating window
          default_mappings = false; -- Bind default mappings
          debug = false; -- Print debug information
          opacity = 10; -- 0-100 opacity level of the floating window where 100 is fully transparent.
          resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
          post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
          references = { -- Configure the telescope UI for slowing the references cycling window.
            telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
          };
          -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
          focus_on_open = true; -- Focus the floating window when opening it.
          dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
          force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
          bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
        }
      end
    },
    -- Lualine (status bar line)
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '│', right = '│'},
            section_separators = { left = '', right = ''},
          },
          sections = {
            lualine_a = {'mode'},
            lualine_b = {
              {'branch', icon = ''},
            },
            lualine_c = {{'filename', path = 1}},
            lualine_x = {'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {{'filename', path = 1}},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
          },
        })
      end,
    },
    -- AVANTE NVIM (CURSOR EMULATION)
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      opts = {
        -- add any opts here
      },
      build = ":AvanteBuild", -- This is optional, recommended tho. Also note that this will block the startup for a bit since we are compiling bindings in Rust.
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to setup it properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
  },
  checker = { enabled = true },
})

-- Animation
vim.g.neovide_cursor_vfx_mode = "wireframe"

-- THEME
-- Function to get current hour in PST
local function get_pst_hour()
    local handle = io.popen("TZ='America/Los_Angeles' date +%H")
    local result = handle:read("*a")
    handle:close()
    return tonumber(result)
end

-- Function to set colorscheme based on time
local function set_colorscheme_by_time()
    local hour = get_pst_hour()
    if hour <= 6 or hour > 19 then
        vim.cmd("colorscheme catppuccin-mocha")
    else
        vim.cmd("colorscheme catppuccin-frappe")
    end
end

-- Call the function to set the colorscheme
set_colorscheme_by_time()


-- Telescope keybinds:
-- leader -> ff opens files
-- leader -> fg greps
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })

-- LSP CONFIGURATION + DIAGNOSTIC SIGNS
local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup()

-- LSP server configurations
local servers = { "lua_ls", "ts_ls" } -- Add more servers as needed

mason_lspconfig.setup({
  ensure_installed = servers,
})

-- LSP setup
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    -- You can add server-specific settings here if needed
  })
end

-- Apply the diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '⬦',
    severity_sort = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Set up diagnostic signs
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- GOTO defn
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    -- Modified gd keybinding to open in new tab
    vim.keymap.set('n', 'gd', function()
      vim.cmd('tab split')
      vim.lsp.buf.definition()
    end, opts)

    -- Keep other keybindings as they are
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end
})

-- GOTO References
vim.api.nvim_set_keymap("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true, silent=true})



