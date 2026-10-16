# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="avit"
plugins=(git zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Aliases
alias ls="ls -al"
alias vim="nvim"
alias p="pnpm"
alias lg="lazygit"

# pnpm (global installs)
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# nvm, switching node versions automatically on .nvmrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if command -v nvm >/dev/null 2>&1; then
  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version
      nvmrc_node_version="$(nvm version "$(<"${nvmrc_path}")")"

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
        nvm use
      fi
    elif [ "$(nvm version default)" != "$(nvm version)" ]; then
      nvm use default >/dev/null
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

# ~/.local/bin (e.g. the claude CLI)
export PATH="$HOME/.local/bin:$PATH"

# Machine-specific settings and secrets (untracked, see zsh/local.zsh.example)
[ -f "$HOME/.config/zsh/local.zsh" ] && source "$HOME/.config/zsh/local.zsh"
