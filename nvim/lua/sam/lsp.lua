-- Shared defaults for all servers
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Register configs
vim.lsp.config("ts_ls", require("lsp.ts_ls"))
vim.lsp.config("luals", require("lsp.luals"))
vim.lsp.config("tailwind", require("lsp.tailwind"))
vim.lsp.config("eslint", require("lsp.eslint"))
-- jdtls is handled by nvim-jdtls plugin

-- Enable
vim.lsp.enable("ts_ls")
vim.lsp.enable("luals")
vim.lsp.enable("tailwind")
vim.lsp.enable("eslint")

-- Config
vim.diagnostic.config({
  virtual_text = true,
})

-- Binds
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>RR", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>D", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- LSP Info command
vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print('No LSP clients attached')
    return
  end
  for _, client in ipairs(clients) do
    print(string.format('Client: %s (id: %d)', client.name, client.id))
  end
end, {})
