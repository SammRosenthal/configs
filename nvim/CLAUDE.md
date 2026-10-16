# Neovim Configuration Guide

This is a modern Neovim configuration using **lazy.nvim** for plugin management and Neovim's **built-in LSP API** (0.10+) for language server configuration.

## Table of Contents

- [Quick Reference](#quick-reference)
- [Architecture Overview](#architecture-overview)
- [Adding New Components](#adding-new-components)
- [Configuration Modules](#configuration-modules)
- [Plugin System](#plugin-system)
- [LSP Configuration](#lsp-configuration)
- [Filetype-Specific Configuration](#filetype-specific-configuration)
- [Customization Patterns](#customization-patterns)

---

## Quick Reference

### File Structure
```
~/.config/nvim/
├── init.lua                    # Entry point - loads lazy.nvim and personal config
├── lazy-lock.json              # Plugin version lockfile (auto-generated)
├── ftplugin/                   # Filetype-specific configurations (optional)
├── lua/
│   ├── config/
│   │   └── lazy.lua           # Lazy.nvim bootstrap & plugin loader
│   ├── sam/                   # Personal configuration namespace
│   │   ├── init.lua          # Module loader
│   │   ├── set.lua           # Vim options (settings)
│   │   ├── remap.lua         # Global keymaps
│   │   └── lsp.lua           # LSP server registration & keymaps
│   ├── plugins/               # Plugin specifications
│   │   ├── configs/          # Complex plugin configurations
│   │   │   ├── telescope.lua
│   │   │   └── nvim-cmp.lua
│   │   └── *.lua             # Individual plugin specs
│   └── lsp/                   # LSP server configurations
│       ├── ts_ls.lua         # TypeScript/JavaScript
│       ├── tailwind.lua      # Tailwind CSS
│       ├── luals.lua         # Lua
│       └── eslint.lua        # ESLint
└── pack/github/start/         # Native Vim packages
    └── copilot.vim
```

### Loading Sequence
1. `init.lua` → Loads lazy.nvim and personal config
2. `config/lazy.lua` → Bootstraps lazy.nvim, sets leader keys, imports plugins
3. `sam/init.lua` → Loads personal modules (remap, set, lsp)
4. `plugins/*.lua` → Lazy-loaded based on events, filetypes, or keymaps

---

## Architecture Overview

### Design Principles
1. **Modular**: Clear separation between settings, keymaps, LSP, and plugins
2. **Lazy Loading**: Plugins load only when needed for fast startup
3. **Two-Tier Config**: Simple plugins inline, complex plugins in separate files
4. **Modern APIs**: Uses Neovim 0.10+ built-in LSP (no lspconfig plugin)
5. **Minimal UI**: Clean interface, no fancy icons or borders

### Key Conventions
- **Leader key**: `<Space>`
- **Local leader**: `\`
- **Personal namespace**: `lua/sam/` (all personal settings here)
- **Plugin configs**: `lua/plugins/` (plugin specifications)
- **LSP configs**: `lua/lsp/` (server-specific settings)
- **Indentation**: 2 spaces throughout

---

## Adding New Components

### Adding a New Plugin

**Simple plugin (inline config):**

1. Create `lua/plugins/plugin-name.lua`:
```lua
return {
  "author/plugin-name",
  lazy = false,  -- or true to lazy load
  event = "VeryLazy",  -- or specify trigger
  keys = {
    { "<leader>xx", "<cmd>PluginCommand<cr>", desc = "Description" },
  },
  opts = {
    -- Plugin options (automatically calls setup())
    option1 = value1,
  },
}
```

**Complex plugin (separate config):**

1. Create `lua/plugins/plugin-name.lua`:
```lua
return {
  "author/plugin-name",
  config = function()
    require("plugins.configs.plugin-name")
  end,
}
```

2. Create `lua/plugins/configs/plugin-name.lua`:
```lua
local plugin = require("plugin-name")
plugin.setup({
  -- Detailed configuration here
})
```

**Examples from this config:**
- Simple: `lua/plugins/conform.lua` (formatter config inline)
- Complex: `lua/plugins/nvim-cmp.lua` (loads `configs/nvim-cmp.lua`)

### Adding a New LSP Server

This config uses Neovim's **built-in LSP API** (NOT nvim-lspconfig).

1. Create `lua/lsp/servername.lua`:
```lua
return {
  cmd = { "language-server-command", "--stdio" },
  filetypes = { "filetype1", "filetype2" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "marker-file", ".git" })
  end,
  settings = {
    -- Server-specific settings
  },
}
```

2. Register in `lua/sam/lsp.lua`:
```lua
vim.lsp.config("servername", require("lsp.servername"))
vim.lsp.enable("servername")
```

**Example**: See `lua/lsp/ts_ls.lua` for TypeScript server config.

### Adding Global Keymaps

Edit `lua/sam/remap.lua`:
```lua
vim.keymap.set("n", "<leader>key", function()
  -- Action here
end, { desc = "Description" })
```

### Adding LSP Keymaps

Edit `lua/sam/lsp.lua` - these apply to ALL LSP servers:
```lua
vim.keymap.set("n", "<leader>xx", function()
  vim.lsp.buf.some_action()
end, { desc = "Description" })
```

### Adding Vim Settings

Edit `lua/sam/set.lua`:
```lua
vim.opt.settingname = value
```

### Adding Filetype-Specific Configuration

Create `ftplugin/filetype.lua`:
```lua
-- Runs automatically when opening files of this type
vim.opt_local.setting = value
vim.keymap.set("n", "<leader>key", function()
  -- Filetype-specific action
end, { buffer = true })
```

---

## Configuration Modules

### `lua/sam/set.lua` - Vim Options

Core editor settings. Key configurations:

```lua
vim.opt.nu = true              -- Line numbers
vim.opt.relativenumber = true  -- Relative line numbers

vim.opt.tabstop = 2           -- Tab width
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true      -- Use spaces, not tabs

vim.opt.smartindent = true

vim.opt.wrap = false          -- No line wrapping

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true       -- Persistent undo

vim.opt.swapfile = false      -- No swap files
vim.opt.backup = false        -- No backup files

vim.opt.hlsearch = false      -- No search highlighting
vim.opt.incsearch = true      -- Incremental search

vim.opt.termguicolors = true  -- True color support

vim.opt.scrolloff = 25        -- Keep 25 lines visible above/below cursor
vim.opt.sidescrolloff = 8

vim.opt.colorcolumn = "100"   -- Visual guide at column 100

vim.opt.updatetime = 50       -- Fast update time (50ms)
```

**To modify**: Edit this file directly and reload config (`:source %`).

### `lua/sam/remap.lua` - Global Keymaps

Non-plugin keymaps. Current mappings:

| Keymap | Mode | Action |
|--------|------|--------|
| `<C-e>` | n | File explorer (`:Ex`) |
| `J` | v | Move selected lines down |
| `K` | v | Move selected lines up |
| `J` | n | Join lines, keep cursor position |
| `<C-d>` | n | Half-page down, centered |
| `<C-u>` | n | Half-page up, centered |
| `n` | n | Next search, centered |
| `N` | n | Previous search, centered |
| `<leader>p` | x | Paste without yanking replaced text |
| `<leader>y` | n/v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |
| `Q` | n | Disabled (no-op) |
| `<C-n>` | n | Next quickfix item |
| `<C-p>` | n | Previous quickfix item |
| `<C-Enter>` | n | Close quickfix list |

**To modify**: Add/edit keymaps in this file using:
```lua
vim.keymap.set("mode", "keys", action, { desc = "Description" })
```

### `lua/sam/lsp.lua` - LSP Configuration

Centralized LSP setup. Two main responsibilities:

**1. Register LSP servers** (using built-in API):
```lua
vim.lsp.config("ts_ls", require("lsp.ts_ls"))
vim.lsp.config("luals", require("lsp.luals"))
vim.lsp.config("tailwind", require("lsp.tailwind"))
vim.lsp.config("eslint", require("lsp.eslint"))

vim.lsp.enable({ "ts_ls", "luals", "tailwind", "eslint" })
```

**2. Define LSP keymaps** (apply to all servers):
| Keymap | Action |
|--------|--------|
| `<leader>gd` | Go to definition |
| `<leader>gR` | Find references |
| `<leader>gI` | Go to implementation |
| `<leader>fi` | Code actions |
| `<leader>RR` | Rename symbol |
| `K` | Hover documentation |
| `<leader>d` | Next diagnostic |
| `<leader>D` | Previous diagnostic |

**Custom command**: `:LspInfo` - Shows attached LSP clients.

**To modify**:
- Add new servers: Create config in `lua/lsp/`, then register here
- Add LSP keymaps: Add to this file (affects all LSP servers)

---

## Plugin System

### Plugin Manager: lazy.nvim

**Bootstrap**: `lua/config/lazy.lua`
- Auto-installs lazy.nvim if not present
- Sets leader keys BEFORE loading plugins
- Imports all plugin specs from `lua/plugins/`

### Lazy Loading Strategy

Plugins load based on:
- **Priority**: Higher priority = loads first (e.g., theme = 1000, completion = 100)
- **Events**: `VeryLazy`, `BufReadPre`, etc.
- **Filetypes**: `ft = "python"` loads only for Python files
- **Keymaps**: `keys = {...}` loads when keymap is pressed
- **Commands**: `cmd = "CommandName"` loads when command is run

### Installed Plugins

| Plugin | Purpose | Lazy? |
|--------|---------|-------|
| **Theme** |
| `github-nvim-theme` | GitHub dark theme | No (priority 1000) |
| **LSP/Completion** |
| `nvim-cmp` | Completion engine | No (priority 100) |
| **Fuzzy Finder** |
| `telescope.nvim` | File/text finder | Yes (keys) |
| `telescope-fzf-native` | FZF sorter | Yes (telescope dep) |
| **Git** |
| `gitsigns.nvim` | Git signs in gutter | Yes |
| `vim-fugitive` | Git commands | Yes (keys) |
| **Syntax/Editing** |
| `nvim-treesitter` | Syntax highlighting | Yes |
| `nvim-comment` | Comment toggle | Yes |
| `conform.nvim` | Code formatting | Yes |
| **Debugging** |
| `nvim-dap` | Debug adapter | Yes (keys) |
| `nvim-dap-ui` | DAP UI | Yes (dap dep) |
| **AI** |
| `copilot.vim` | GitHub Copilot | Yes |
| **UI** |
| `lualine.nvim` | Statusline | Yes |

### Plugin Configuration Patterns

**Pattern 1: Inline with `opts`** (auto-calls `.setup()`)
```lua
-- lua/plugins/simple-plugin.lua
return {
  "author/plugin",
  opts = {
    option1 = value1,
  },
}
```

**Pattern 2: Inline with `config` function**
```lua
-- lua/plugins/medium-plugin.lua
return {
  "author/plugin",
  config = function()
    require("plugin").setup({
      option1 = value1,
    })
  end,
}
```

**Pattern 3: External config file** (for complex setups)
```lua
-- lua/plugins/complex-plugin.lua
return {
  "author/plugin",
  config = function()
    require("plugins.configs.complex-plugin")
  end,
}

-- lua/plugins/configs/complex-plugin.lua
local plugin = require("plugin")
-- ... extensive configuration ...
```

**Examples in this config:**
- Pattern 1: `conform.nvim`, `gitsigns.nvim`
- Pattern 2: `github-nvim-theme`, `lualine.nvim`
- Pattern 3: `telescope.nvim`, `nvim-cmp`

### Key Plugin Keymaps

**Telescope** (fuzzy finder):
- `<leader>ff` - Find files
- `<leader>?` - Recent files
- `<leader>fw` - Live grep
- `<leader>FW` - Live multigrep (custom: `pattern  *.ext`)
- `<leader>en` - Edit Neovim config

**Git**:
- `<leader>gs` - Git status (fugitive)

**DAP** (debugging):
- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue
- `<leader>di` - Step into
- `<leader>do` - Step over
- `<leader>dO` - Step out
- `<leader>dt` - Terminate
- `<leader>du` - Toggle UI

**Completion** (nvim-cmp):
- `<C-n>` / `<C-p>` - Navigate items
- `<CR>` - Confirm selection
- `<C-Space>` - Trigger completion

---

## LSP Configuration

### Modern Built-in LSP API

This config uses **Neovim 0.10+ built-in LSP** (`vim.lsp.config` / `vim.lsp.enable`), NOT the nvim-lspconfig plugin.

**Advantages:**
- No external dependencies for LSP setup
- More explicit configuration
- Direct control over server settings
- Faster startup (no lspconfig layer)

### LSP Server Configurations

All server configs live in `lua/lsp/` and follow this structure:

```lua
return {
  cmd = { "server-command", "--stdio" },
  filetypes = { "filetype1", "filetype2" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "marker-files", ".git" })
  end,
  settings = {
    -- Server-specific settings
  },
}
```

### Configured Servers

#### TypeScript/JavaScript (`lua/lsp/ts_ls.lua`)
```lua
{
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "tsconfig.json", "jsconfig.json", "package.json", ".git" })
  end,
}
```

**Root detection**: Looks for `tsconfig.json`, `jsconfig.json`, `package.json`, or `.git`.

#### Lua (`lua/lsp/luals.lua`)
```lua
{
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".luarc.json", ".luarc.jsonc", ".git" })
  end,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },  -- Recognize 'vim' global
    },
  },
}
```

**Key feature**: Recognizes `vim` as a global (no warnings in Neovim config files).

#### Tailwind CSS (`lua/lsp/tailwind.lua`)
```lua
{
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "tailwind.config.js", "tailwind.config.ts", "package.json", ".git" })
  end,
}
```

**Root detection**: Looks for Tailwind config files.

#### ESLint (`lua/lsp/eslint.lua`)
Key features:

- **Flat config detection**: Auto-detects `eslint.config.js/mjs/cjs`
- **Yarn PnP support**: Handles Yarn 2+ workspaces
- **Custom command**: `:LspEslintFixAll` - Fix all ESLint errors
- **Dynamic root detection**: Checks `package.json` for ESLint config
- **Custom handlers**: Processes ESLint-specific messages

**Root markers**:
```lua
{
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "package.json",
}
```

### Adding a New LSP Server

1. **Create server config** `lua/lsp/myserver.lua`:
```lua
return {
  cmd = { "myserver-lsp", "--stdio" },
  filetypes = { "myfiletype" },
  root_dir = function(fname)
    return vim.fs.root(fname, { ".myproject", ".git" })
  end,
  settings = {
    myserver = {
      setting1 = value1,
    },
  },
}
```

2. **Register in** `lua/sam/lsp.lua`:
```lua
vim.lsp.config("myserver", require("lsp.myserver"))
vim.lsp.enable("myserver")
```

3. **Install the server** (if not available):
- Via package manager: `brew install myserver-lsp`
- Manually: Download binary

---

## Filetype-Specific Configuration

### How Filetype Configs Work

Files in `ftplugin/` run automatically when opening a file of that type.

**Naming convention**: `ftplugin/{filetype}.lua`
- `ftplugin/python.lua` → Runs for `.py` files
- `ftplugin/go.lua` → Runs for `.go` files

### Creating Filetype Configs

**Example**: Python configuration (`ftplugin/python.lua`)

```lua
-- Set Python-specific options
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Python-specific keymaps
vim.keymap.set("n", "<leader>pr", function()
  vim.cmd("!python %")
end, { buffer = true, desc = "Run Python file" })

-- Auto-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    vim.lsp.buf.format()
  end,
})
```

**Key points**:
- Use `vim.opt_local` for buffer-local settings
- Use `{ buffer = true }` for buffer-local keymaps
- Can set up autocommands specific to this filetype
- Runs automatically when opening files of this type

---

## Customization Patterns

### Common Modification Tasks

#### 1. Change Color Scheme

**Current**: GitHub Dark Default

**To change**:
```lua
-- lua/plugins/theme.lua
return {
  "folke/tokyonight.nvim",  -- Change to your preferred theme
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
```

#### 2. Add Auto-Format on Save

**Current**: Handled by conform.nvim with LSP fallback.

**To modify formatters** (`lua/plugins/conform.lua`):
```lua
formatters_by_ft = {
  lua = { "stylua" },
  python = { "isort", "black" },
  rust = { "rustfmt" },
  javascript = { "prettierd" },
  -- Add your filetypes here
  go = { "gofmt", "gofumpt" },
},
```

**To disable auto-format**:
```lua
format_on_save = nil,  -- Instead of the current function
```

#### 3. Add More Treesitter Languages

**Edit** `lua/plugins/treesitter.lua`:
```lua
ensure_installed = {
  "c", "lua", "rust", "javascript", "typescript",
  -- Add more languages:
  "python", "go", "ruby", "bash",
},
```

#### 4. Modify Completion Sources

**Edit** `lua/plugins/configs/nvim-cmp.lua`:
```lua
sources = cmp.config.sources({
  { name = "lazydev", group_index = 0 },
  { name = "nvim_lsp" },
  { name = "path" },
  { name = "buffer" },
  -- Add more sources:
  { name = "emoji" },  -- Requires cmp-emoji
}),
```

#### 5. Change Leader Key

**Edit** `lua/config/lazy.lua` (BEFORE lazy setup):
```lua
vim.g.mapleader = ","  -- Change from space to comma
vim.g.maplocalleader = "\\"
```

**Important**: Must change BEFORE loading plugins.

#### 6. Add Custom Telescope Picker

**Edit** `lua/plugins/configs/telescope.lua`:
```lua
-- Add new keymap
vim.keymap.set("n", "<leader>fc", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.stdpath("config"),
    prompt_title = "Config Files",
  })
end, { desc = "Find config files" })
```

#### 7. Disable Plugin Temporarily

**Edit plugin file** (e.g., `lua/plugins/copilot.lua`):
```lua
return {
  "github/copilot.vim",
  enabled = false,  -- Add this line
}
```

Or delete/rename the file to `copilot.lua.bak`.

#### 8. Add Debugging for Another Language

**Example**: Python debugging (`lua/plugins/nvim-dap.lua`):
```lua
local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
  },
}
```

### Best Practices

#### File Organization
1. **Keep personal configs in `lua/sam/`** - Don't mix with plugins
2. **One plugin per file** in `lua/plugins/`
3. **Complex configs get their own file** in `lua/plugins/configs/`
4. **LSP configs stay in `lua/lsp/`** - Separate from plugin configs

#### Naming Conventions
- Plugin files: `lua/plugins/plugin-name.lua`
- LSP configs: `lua/lsp/server-name.lua`
- Config files: `lua/plugins/configs/plugin-name.lua`
- Use kebab-case for filenames

#### Lazy Loading
- **Don't lazy load**: themes, completion, essential plugins
- **Do lazy load**: Git tools, debugging, language-specific plugins
- **Lazy load on keys**: Tools you trigger manually (Telescope, Git)
- **Lazy load on filetype**: Language-specific plugins

#### Keymap Organization
- **Global keymaps**: `lua/sam/remap.lua`
- **LSP keymaps**: `lua/sam/lsp.lua` (all servers)
- **Plugin keymaps**: In plugin spec (`keys = { ... }`)
- **Filetype keymaps**: In `ftplugin/{type}.lua`

#### Testing Changes
1. **Reload config**: `:source $MYVIMRC` or restart Neovim
2. **Check plugin status**: `:Lazy` (shows all plugins)
3. **Check LSP**: `:LspInfo` (shows attached servers)
4. **Check keymaps**: `:map <leader>` (shows leader mappings)
5. **Debug errors**: `:messages` (shows error messages)

### Troubleshooting

#### Plugin not loading
```vim
:Lazy                   " Check plugin status
:Lazy load plugin-name  " Force load plugin
:Lazy sync              " Sync all plugins
```

#### LSP not attaching
```vim
:LspInfo                " Check LSP status
:checkhealth lsp        " Diagnose LSP issues
```

#### Keymaps not working
```vim
:map <leader>key        " Check if keymap exists
:verbose map <leader>key " See where keymap was set
```

#### Performance issues
```vim
:Lazy profile           " See plugin load times
:checkhealth            " Check overall health
```

### Useful Commands

| Command | Purpose |
|---------|---------|
| `:Lazy` | Manage plugins |
| `:Lazy sync` | Update all plugins |
| `:LspInfo` | Show LSP status |
| `:LspEslintFixAll` | Fix ESLint errors |
| `:Telescope` | Open Telescope |
| `:checkhealth` | Diagnose issues |
| `:source %` | Reload current file |

---

## Quick Start Guide

### Fresh Install
1. Clone your config or copy to `~/.config/nvim/`
2. Start Neovim - lazy.nvim auto-installs
3. Run `:Lazy sync` to install all plugins
4. Install LSP servers via package manager (e.g., `brew install typescript-language-server lua-language-server`)
5. Restart Neovim

### Making Changes
1. Edit the appropriate file (see sections above)
2. Reload: `:source $MYVIMRC` or restart
3. If adding plugins: `:Lazy sync`
4. If adding LSP: Install server via package manager or manually

### Getting Help
- Read plugin docs: `:help plugin-name`
- Check Neovim help: `:help vim.lsp`
- Lazy.nvim docs: https://github.com/folke/lazy.nvim
- This config's reference: This CLAUDE.md file

---

## Summary

This configuration is designed for:
- **Modern Neovim** (0.10+) with built-in LSP
- **Fast startup** via lazy loading
- **TypeScript/JavaScript development** (primary focus)
- **Web development** (Tailwind, React)
- **Clean, minimal UI** (no fancy icons)
- **Easy modification** (clear structure, documented patterns)

### Key Files to Remember
- `lua/sam/` - Your personal settings
- `lua/plugins/` - Plugin specifications
- `lua/lsp/` - LSP server configs
- `ftplugin/` - Filetype-specific configs

### Philosophy
- **Modular**: Each concern in its own file
- **Explicit**: Clear, understandable configuration
- **Minimal**: Only what's needed, no bloat
- **Modern**: Uses latest Neovim features

