return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_markers = { '.luarc.json', '.luarc.jsonc', '.git' }
    local found = vim.fs.find(root_markers, { path = fname, upward = true })[1]
    on_dir(found and vim.fs.dirname(found) or nil)
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  },
}
