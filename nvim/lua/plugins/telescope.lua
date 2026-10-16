return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>ff", desc = "Find files" },
    { "<leader>?", desc = "Recent files" },
    { "<leader>fw", desc = "Live grep" },
    { "<leader>FW", desc = "Multi grep" },
    { "<leader>en", desc = "Edit Neovim config" },
  },
  opts = {
    extensions = {
      wrap_results = true,
      fzf = {},
    },
  },
  config = function()
    require "plugins.configs.telescope"
  end,
}
