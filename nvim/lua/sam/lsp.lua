vim.diagnostic.config({
  virtual_text = true,
})

vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gA", vim.lsp.buf.references, opts)
vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>RR", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>D", vim.diagnostic.goto_prev, opts)

vim.lsp.enable("ts_ls")
vim.lsp.enable("luals")
