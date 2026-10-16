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
| pnpm       | Homebrew `pnpm@8` comes first on PATH, then `pnpm@9`                       |
| Java       | `JAVA_HOME` set to Temurin 21 when it's installed                         |
| bun        | `~/.bun/bin` on PATH, with completions                                    |
| PATH extras | `~/bin`, `~/.local/bin`, sonarqube-cli                                   |
| ssh        | No agent is started; the macOS keychain agent handles keys (`UseKeychain` in `~/.ssh/config`) |

## Local settings and secrets

`~/.config/zsh/local.zsh` is sourced last and never committed. Put tokens and
machine-specific overrides there. [local.zsh.example](local.zsh.example) lists
what it currently holds: the Jira API token, and the Claude Code Bedrock
switch and token limits.
