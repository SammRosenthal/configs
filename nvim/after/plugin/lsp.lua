local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"ts_ls",
	"rust_analyzer",
	"pyright",
	"clangd",
	"jdtls",
})

local cmp = require("cmp")
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<CR>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

-- disabled tab navigation to open for other
-- uses like copilot etc...
cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gA", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>fi", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>RR", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>D", vim.diagnostic.goto_prev, opts)
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})
