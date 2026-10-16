# zsh

`.zshrc` uses oh-my-zsh (theme `avit`). Linked to `~/.zshrc`.

## Aliases

| Alias | Runs                 |
| ----- | -------------------- |
| `ls`  | `ls -al`             |
| `vim` | `nvim`               |
| `p`   | `pnpm`               |
| `lg`  | `lazygit`            |

## oh-my-zsh plugins

- **git:** short git aliases. The ones worth remembering:

  | Alias    | Runs                                        |
  | -------- | ------------------------------------------- |
  | `gst`    | `git status`                                |
  | `gaa`    | `git add --all`                             |
  | `gcmsg`  | `git commit -m`                             |
  | `gco`    | `git checkout`                              |
  | `gcb`    | `git checkout -b`                           |
  | `gd`     | `git diff`                                  |
  | `gl`     | `git pull`                                  |
  | `gp`     | `git push`                                  |
  | `glog`   | `git log --oneline --decorate --graph`      |

  `alias | grep git` lists all of them.

- **zsh-autosuggestions:** suggests the rest of the command from history in
  grey. Press **→** (or `End`) to accept it. This is a custom plugin, cloned into
  `~/.oh-my-zsh/custom/plugins/` (see the root README).

## Environment

| What       | Behaviour                                                                 |
| ---------- | ------------------------------------------------------------------------- |
| Editor     | `EDITOR` and `VISUAL` are `nvim`                                          |
| Node       | nvm. `cd` into a folder with `.nvmrc` and it switches (installing if missing); leaving it switches back to the default |
| pnpm       | Homebrew `pnpm`; global installs go to `~/Library/pnpm`                   |
| bun        | `~/.bun/bin` on PATH, with completions                                    |
| PATH extras | `~/.local/bin` (e.g. the `claude` CLI)                                   |
| ssh        | No agent is started; the macOS keychain agent handles keys (`UseKeychain` in `~/.ssh/config`) |

## Local settings and secrets

`~/.config/zsh/local.zsh` is sourced last and never committed. Put tokens and
machine-specific overrides there, such as tools installed only on this
machine. [local.zsh.example](local.zsh.example) shows the shape.
