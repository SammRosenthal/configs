local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.sqlformat,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.formatting.rustfmt,
  },
  default_timeout = -1,
})
