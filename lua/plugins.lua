local status, packer = pcall(require, "packer")

if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  -- installs packages
  use 'wbthomason/packer.nvim'

  -- helper functions for packages I'm using
  use 'nvim-lua/plenary.nvim'

  -- intellisense and autocomplete
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/nvim-cmp'
  use { 'tzachar/cmp-tabnine', run = './install.sh', requires = 'hrsh7th/nvim-cmp' }
  -- used as helper func in cmp setup
  use 'L3MON4D3/LuaSnip'

  -- syntax highlighting and file parsing
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  }

  -- Easy to use LSP config (This can get replaced by native nvim stuff soon TM)
  use 'neovim/nvim-lspconfig'

  -- auto install needed LSPs and easy access to more of them via `:Mason`
  -- like a package manager for LSPs
  use 'williamboman/mason.nvim'
  -- allows mason to hook up with 'neovim/nvim-lspconfig'
  use 'williamboman/mason-lspconfig.nvim'

  -- improved UI and helpers to interact with the nvim LSP while navigating a codebase
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  -- Gives Telescope like UI for non Telescope actions like code actions
  use { 'nvim-telescope/telescope-ui-select.nvim' }

  -- nice info line at bottom of vim window
  use 'nvim-lualine/lualine.nvim'

  -- solid commenting ability for all languages block and single line
  use 'terrortylor/nvim-comment'

  -- auto closing parens and brackets etc...
  use 'windwp/nvim-autopairs'
  -- auto closing JSX and DOM tags
  use 'windwp/nvim-ts-autotag'

  -- git highlighting in gutter to show new lines modified lines and deleted lines
  use 'lewis6991/gitsigns.nvim'

  -- this might be able to be removed???
  -- Adds symbols to the auto complete about what the item is
  use 'onsails/lspkind.nvim'

  -- Themes
  use 'folke/tokyonight.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use { 'rose-pine/neovim', as ='rose-pine' }
end)
