-- Aki's neovim lua dotfile
-- Best used with neovide
-- Comments below explaining functionality

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
vim.o.guifont = "PragmataPro Mono Liga:h16"

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



-- Setup lazy nvim
require("lazy").setup({
  spec = {
    -- Copilot
    { "github/copilot.vim", name = "copilot", lazy = false },
    -- Theme
    { "EdenEast/nightfox.nvim", name = "nightfox", lazy = false, priority = 1000 },
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
    }
  },
  install = { colorscheme = { "nightfox" } },  
  checker = { enabled = true },
})

-- Animation
vim.g.neovide_cursor_vfx_mode = "wireframe"

-- Set theme
vim.cmd("colorscheme dayfox")


-- Telescope keybinds:
-- leader -> ff opens files
-- leader -> fg greps
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Help tags' })

