return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_markers = {'tsconfig.json', 'jsconfig.json', 'package.json', '.git'}
    local found = vim.fs.find(root_markers, { path = fname, upward = true })[1]
    on_dir(found and vim.fs.dirname(found) or nil)
  end,
}

