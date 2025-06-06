return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
    "nvim-lua/plenary.nvim",
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
