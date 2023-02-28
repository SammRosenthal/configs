local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
  'pyright',
  'clangd',
  'jdtls',
})

-- Fix Undefined global 'vim'
-- lsp.configure('sumneko_lua', {
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' }
--       }
--     }
--   }
-- })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
  -- disable completion with tab
  -- this helps with copilot setup
  ['<Tab>'] = nil,
  ['<S-Tab>'] = nil,
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})


lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>D", vim.diagnostic.goto_prev, opts)
end)


lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})
