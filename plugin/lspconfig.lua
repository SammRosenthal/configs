local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end



local function baseConfig(_config)
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    on_attach = function()
      -- run code action
      vim.keymap.set('n', '<leader>fi', function() vim.lsp.buf.code_action() end)
      -- format file
      vim.keymap.set('n', '<leader>FF', function() vim.lsp.buf.formatting_sync() end)
      -- show hover help
      vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end)
      -- refactor rename in your curr file
      vim.keymap.set('n', 'rr', function() vim.lsp.buf.rename() end)
      -- show hover window with diagnostic info
      vim.keymap.set('n', '<leader>d', function() vim.diagnostic.goto_next() end)
      -- show hover window with diagnostic info
      -- vim.keymap.set('n', '<leader>D', function() vim.diagnostic.open_float() end)
    end,
    apply = true,
  }, _config or {})
end

-- typescript
nvim_lsp.tsserver.setup(baseConfig({
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
}))

-- eslint
nvim_lsp.eslint.setup(baseConfig({
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
}))

-- lua
nvim_lsp.sumneko_lua.setup(baseConfig({
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },

      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  }
}))

-- go
nvim_lsp.gopls.setup(baseConfig({
  cmd = { "gopls", "serve" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
}))

-- rust
-- cmd = { "rustup", "run", "nightly", "rust-analyzer" },
nvim_lsp.rust_analyzer.setup(baseConfig())

-- tailwind
nvim_lsp.tailwindcss.setup(baseConfig())

-- for showing inline errors & hints
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
}
)

-- gutter symbols for inline errors & hints
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = {
    prefix = '>'
  },
  update_in_insert = true,
  float = {
    source = "always", -- Or "if_many"
  },
})


