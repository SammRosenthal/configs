return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = "VeryLazy",
  opts_extend = { "ensure_installed" },
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "typescript", "typescriptreact" },
      },
      indent = { enable = true },
      auto_install = true,
      ensure_installed = {
        "c", "lua", "rust", "javascript", "typescript", "svelte", "astro", "css", "tsx", "java"
      },
    })
  end
}
