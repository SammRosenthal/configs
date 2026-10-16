#!/usr/bin/env bash
# Symlink the configs in this repo into place.
#
# Safe to re-run: correct links are left alone, and anything else already at a
# target path is moved to ~/.config-backup/<timestamp>/ rather than deleted.
#
# Usage: ./install.sh [--dry-run]
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

run() {
  if (( DRY_RUN )); then echo "  would: $*"; else "$@"; fi
}

backup() {
  local path="$1"
  local dest="$BACKUP/${path#"$HOME"/}"
  echo "  backup: $path -> $dest"
  run mkdir -p "$(dirname "$dest")"
  run mv "$path" "$dest"
}

link() {
  local src="$REPO/$1" dst="$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    return
  fi
  [[ -e "$dst" || -L "$dst" ]] && backup "$dst"
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  echo "linked  $dst -> $src"
}

# source (repo-relative)     target
link zsh/.zshrc              "$HOME/.zshrc"
link nvim                    "$HOME/.config/nvim"
link ghostty/config          "$HOME/.config/ghostty/config"
link lazygit/config.yml      "$HOME/.config/lazygit/config.yml"

# Ghostty on macOS also reads this file, after the XDG one, so it would override
# the linked config. Move it out of the way.
GHOSTTY_MACOS="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
[[ -e "$GHOSTTY_MACOS" && ! -L "$GHOSTTY_MACOS" ]] && backup "$GHOSTTY_MACOS"

# Local, untracked files: seed from the examples if missing.
seed() {
  local example="$REPO/$1" dst="$2"
  if [[ ! -e "$dst" ]]; then
    run mkdir -p "$(dirname "$dst")"
    run cp "$example" "$dst"
    echo "created $dst (from $1, fill it in)"
  fi
}
seed zsh/local.zsh.example       "$HOME/.config/zsh/local.zsh"

# nvim persistent undo (see nvim/lua/sam/set.lua)
run mkdir -p "$HOME/.vim/undodir"

echo "done"
