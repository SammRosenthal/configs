# configs

Personal macOS dotfiles: zsh, Neovim, git, Ghostty, lazygit, opencode, and Zed.

The repo lives at `~/code/configs`, and `install.sh` symlinks each config into
place. Editing a config in its normal location edits the repo, so `git status`
here shows any drift.

## Quick reference

Each folder has a README listing what that config sets up: keymaps, aliases,
plugins, and the commands worth remembering.

- [nvim](nvim/README.md): keymaps, LSP, completion, formatting, debugging, Java
- [zsh](zsh/README.md): aliases, oh-my-zsh plugins, environment, local secrets
- [git](git/README.md): signing, merge behaviour, delta, work identity, global ignore
- [ghostty](ghostty/README.md): theme, font, Shift+Enter, CLI commands
- [lazygit](lazygit/README.md): key cheat sheet
- [opencode](opencode/README.md): settings and plugins
- [zed](zed/README.md): settings

## Layout

| Repo path                | Linked to                              |
| ------------------------ | -------------------------------------- |
| `zsh/.zshrc`             | `~/.zshrc`                             |
| `git/gitconfig`          | `~/.gitconfig`                         |
| `git/ignore`             | `~/.config/git/ignore` (global ignore) |
| `nvim/`                  | `~/.config/nvim`                       |
| `ghostty/config`         | `~/.config/ghostty/config`             |
| `lazygit/config.yml`     | `~/.config/lazygit/config.yml`         |
| `opencode/opencode.json` | `~/.config/opencode/opencode.json`     |
| `opencode/plugins/`      | `~/.config/opencode/plugins`           |
| `zed/settings.json`      | `~/.config/zed/settings.json`          |
| `Brewfile`               | used by `brew bundle`                  |

Machine-specific values and secrets are **never committed**. They go in local
files that `install.sh` creates from the committed examples:

| Local file                  | Template                      | Holds                          |
| --------------------------- | ----------------------------- | ------------------------------ |
| `~/.config/zsh/local.zsh`   | `zsh/local.zsh.example`       | API tokens, Bedrock settings   |
| `~/.gitconfig-work`         | `git/gitconfig-work.example`  | Work git identity              |

## Setting up a new machine

1. **Xcode command line tools** (git, make, a C compiler):

   ```bash
   xcode-select --install
   ```

2. **Homebrew** (see [brew.sh](https://brew.sh)):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

3. **SSH keys.** Restore `~/.ssh/id_ed25519` (GitHub auth) and
   `~/.ssh/id_ed25519_signing` (commit signing) from your password manager, or
   generate new ones and add them to GitHub as an authentication key and a
   signing key. `~/.ssh/config` needs `UseKeychain yes` and
   `AddKeysToAgent yes`. `.zshrc` doesn't start an ssh-agent; it relies on the
   macOS keychain agent.

4. **Clone this repo:**

   ```bash
   mkdir -p ~/code && git clone git@github.com:SammRosenthal/configs.git ~/code/configs
   ```

5. **Install packages:**

   ```bash
   brew bundle --file ~/code/configs/Brewfile
   ```

   The Brewfile is a full `brew bundle dump`, including VS Code extensions and
   Go tools. Edit it first if you don't want everything.

6. **oh-my-zsh, zsh-autosuggestions and nvm.** `.zshrc` expects all three:

   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
   ```

   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
   ```

   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | PROFILE=/dev/null bash
   ```

   `PROFILE=/dev/null` stops the nvm installer from appending to `.zshrc`,
   which already loads nvm.

7. **Link the configs.** Preview first, then run:

   ```bash
   ~/code/configs/install.sh --dry-run
   ```

   ```bash
   ~/code/configs/install.sh
   ```

   Anything already at a target path is moved to `~/.config-backup/<timestamp>/`.
   The script is safe to re-run.

8. **Fill in the local files** that `install.sh` created: `~/.config/zsh/local.zsh`
   and `~/.gitconfig-work`. Get the values from your password manager. Then
   open a new shell.

9. **Neovim.** Open `nvim`. lazy.nvim bootstraps itself and installs all plugins
   at the versions pinned in `nvim/lazy-lock.json`. Plugins never update on
   their own: run `:Lazy update` when you want newer versions, then commit the
   lockfile. On a machine that has drifted, `:Lazy restore` goes back to the
   pinned versions.

   Language servers and formatters aren't managed by Neovim. The Brewfile covers
   `lua-language-server`, `stylua` and `prettierd`; install the rest with:

   ```bash
   npm i -g typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server
   ```

   Java uses `jdtls` and Temurin 21 from the Brewfile. For debugging, build
   `java-debug` (it isn't in Homebrew) into the path `nvim/ftplugin/java.lua`
   expects:

   ```bash
   git clone https://github.com/microsoft/java-debug ~/.local/share/java-debug
   ```

   ```bash
   cd ~/.local/share/java-debug && ./mvnw clean install -DskipTests
   ```

10. **Re-auth CLIs.** These keep credentials in `~/.config` and are
    intentionally not tracked: `gh auth login`, `glab auth login`, `acli`, and
    Copilot (`:Copilot setup` in Neovim).

## Day to day

- **Edit configs in place** (e.g. `~/.config/nvim/...`). The symlinks point
  into this repo, so commit and push from `~/code/configs`.
- **Add a new config:** move it into the repo, add a `link` line to
  `install.sh`, and re-run the script.
- **Refresh the Brewfile:**

  ```bash
  brew bundle dump --file ~/code/configs/Brewfile --force
  ```

  The dump drops the hand-added `ghostty` and `zed` casks at the bottom if
  they aren't Homebrew-installed, so re-add them afterwards.

- **Neovim plugin versions:** `lazy-lock.json` is gitignored, and plugins
  auto-update on startup (`nvim/lua/config/lazy.lua`). Machines therefore run
  whatever the latest plugin versions are rather than pinned ones.
