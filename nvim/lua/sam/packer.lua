-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
      }
    },
  })

  -- themes
  use({ "projekt0n/github-nvim-theme" })
  --  themes

  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  use("tpope/vim-fugitive")

  -- AI
  use("github/copilot.vim")

  use({
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup()
    end,
  })

  use("terrortylor/nvim-comment")

  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })

  use("lewis6991/gitsigns.nvim")
end)
