return {
	'stevearc/conform.nvim',
	opts = {
		format_after_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
			async = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			go = { "gofmt", "gofumpt" },
		}
	},
}
