# nvim

Quick reference for this Neovim config. `<leader>` is **Space**.

For how the config is structured and how to extend it, see [CLAUDE.md](CLAUDE.md).

## Editing and navigation (`lua/sam/remap.lua`)

| Keys                  | Mode   | Does                                             |
| --------------------- | ------ | ------------------------------------------------ |
| `<C-e>`               | normal | File explorer (netrw)                            |
| `J` / `K`             | visual | Move selected lines down / up                    |
| `<C-d>` / `<C-u>`     | normal | Half-page down / up, cursor kept centred         |
| `n` / `N`             | normal | Next / previous search match, centred            |
| `<leader>p`           | visual | Paste over the selection without yanking it      |
| `<leader>y` / `<leader>Y` | normal, visual | Yank to the system clipboard (`Y` = line) |
| `<C-n>` / `<C-p>`     | normal | Next / previous quickfix item                    |
| `<C-Enter>`           | normal | Close the quickfix list                          |
| `Q`                   | normal | Disabled (no accidental Ex mode)                 |

## Finding things (telescope)

| Keys          | Does                                                                                  |
| ------------- | ------------------------------------------------------------------------------------- |
| `<leader>ff`  | Find files                                                                            |
| `<leader>?`   | Recently opened files                                                                 |
| `<leader>fw`  | Live grep                                                                             |
| `<leader>FW`  | Multi grep: type a pattern, **two spaces**, then a file glob (e.g. `useState  *.tsx`) |
| `<leader>en`  | Find files in this nvim config                                                        |

Fuzzy matching uses fzf-native (`telescope-fzf-native.nvim`, built with `make`).

## LSP (`lua/sam/lsp.lua`)

Servers: `ts_ls`, `eslint`, `tailwind`, `luals`, plus `jdtls` for Java (see below).

| Keys                      | Does                         |
| ------------------------- | ---------------------------- |
| `K`                       | Hover docs                   |
| `<leader>gd`              | Go to definition             |
| `<leader>gr`              | Find references              |
| `<leader>gi`              | Go to implementation         |
| `<leader>fi`              | Code actions                 |
| `<leader>RR`              | Rename symbol                |
| `<leader>d` / `<leader>D` | Next / previous diagnostic   |
| `:LspInfo`                | List attached LSP clients    |
| `:LspEslintFixAll`        | Apply all ESLint fixes (JS/TS buffers) |

## Completion (nvim-cmp) and Copilot

| Keys              | Does                                        |
| ----------------- | ------------------------------------------- |
| `<C-n>` / `<C-p>` | Next / previous completion item (insert)    |
| `<CR>`            | Accept the completion                       |
| `<C-Space>`       | Open the completion menu                    |
| `<Tab>`           | Accept the Copilot suggestion               |
| `<M-]>` / `<M-[>` | Next / previous Copilot suggestion          |
| `<C-]>`           | Dismiss the Copilot suggestion              |

Sources: LSP, file paths, buffer words, and lazydev (Neovim Lua API, in Lua
files). Tailwind classes show a colour swatch. Run `:Copilot setup` once per
machine to sign in.

## Formatting (conform)

Formats automatically after every save, asynchronously, falling back to the LSP
formatter when none is configured:

| Filetype          | Formatter            |
| ----------------- | -------------------- |
| JS / TS / JSX / TSX | `prettierd`        |
| Lua               | `stylua`             |
| Python            | `isort`, then `black` |
| Rust              | `rustfmt`            |
| Go                | `gofmt`, `gofumpt`   |

`:ConformInfo` shows which formatter applies to the current buffer.

## Git

| Keys / command          | Does                                    |
| ----------------------- | --------------------------------------- |
| `<leader>gs`            | Fugitive status (`:Git`)                |
| `:Git blame`, `:Git log` | Any git command via fugitive           |
| `:Gitsigns preview_hunk` | Show the change under the cursor       |
| `:Gitsigns blame_line`  | Blame for the current line              |
| `:Gitsigns reset_hunk`  | Discard the hunk under the cursor       |

gitsigns shows added/changed/removed lines in the sign column. It has no custom
keymaps.

## Commenting (nvim-comment)

| Keys            | Does                              |
| --------------- | --------------------------------- |
| `gcc`           | Toggle comment on the line        |
| `gc{motion}`    | Toggle comment over a motion (e.g. `gcap`) |
| `gc`            | Toggle comment on the selection (visual) |

## Debugging (nvim-dap)

| Keys          | Does                    |
| ------------- | ----------------------- |
| `<leader>db`  | Toggle breakpoint       |
| `<leader>dc`  | Start / continue        |
| `<leader>di`  | Step into               |
| `<leader>do`  | Step over               |
| `<leader>dO`  | Step out                |
| `<leader>dt`  | Terminate               |
| `<leader>du`  | Toggle the DAP UI       |

The DAP UI opens and closes with the debug session.

## Java (`ftplugin/java.lua`, Java buffers only)

| Keys          | Mode   | Does                                  |
| ------------- | ------ | ------------------------------------- |
| `<leader>jr`  | normal | `mvn spring-boot:run`                 |
| `<leader>jt`  | normal | `mvn test`                            |
| `<leader>jb`  | normal | `mvn clean install`                   |
| `<leader>jo`  | normal | Organize imports                      |
| `<leader>ju`  | normal | Reload project config (after `pom.xml` changes) |
| `<leader>jv`  | visual | Extract variable                      |
| `<leader>jm`  | visual | Extract method                        |

The project root is the top-level Maven aggregator `pom.xml` (one with
`<modules>`), falling back to `.git`/`mvnw`/`gradlew`. Each project gets its own
JDTLS workspace under `~/.local/share/nvim/jdtls-workspace/`. The debugger needs
`java-debug` built locally (see the root README).

## Plugins (lazy.nvim)

Versions are pinned in `lazy-lock.json` and never update on their own.

| Command         | Does                                                     |
| --------------- | -------------------------------------------------------- |
| `:Lazy`         | Plugin manager UI                                        |
| `:Lazy update`  | Update plugins (then commit `lazy-lock.json`)            |
| `:Lazy restore` | Go back to the versions pinned in the lockfile           |
| `:TSUpdate`     | Update treesitter parsers (missing ones auto-install)    |

## Editor settings (`lua/sam/set.lua`)

- Relative line numbers, ruler at column 100, `scrolloff` 25.
- 2-space indentation with spaces, no line wrap.
- No swap or backup files; persistent undo in `~/.vim/undodir`.
- Block cursor in every mode; no search highlighting after the search.
- Theme: `github_dark_default`. Statusline: lualine.
