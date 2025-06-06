local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

require("telescope").load_extension("fzf")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<C-q>"] = actions.send_to_qflist },
      n = { ["<C-q>"] = actions.send_to_qflist },
    },
  },
  extensions = {
    fzf = {},
  },
})

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return vim.tbl_flatten {
        args,
        {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Live Multi Grep",
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = sorters.empty(),
  }):find()
end

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>?", builtin.oldfiles)
vim.keymap.set("n", "<leader>fw", builtin.live_grep)
vim.keymap.set("n", "<leader>FW", live_multigrep)
vim.keymap.set("n", "<leader>en", function()
  builtin.find_files {
    cwd = vim.fn.stdpath("config")
  }
end)
