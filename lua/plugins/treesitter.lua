return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  opts_extend = { "ensure_installed" },
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    auto_install = true,
    ensure_installed = {
      "c", "lua", "rust", "help", "javascript", "typescript", "svelte", "java", "astro", "css", "tsx" },
  },
}
