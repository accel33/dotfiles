#!/usr/bin/env bash
# Crea los symlinks de los dotfiles hacia sus ubicaciones esperadas.
# Uso: ./install.sh
set -e
DF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "backup: $dst -> $dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "linked: $dst -> $src"
}

link "$DF/nvim"                   "$HOME/.config/nvim"
link "$DF/zsh/.zshrc"             "$HOME/.zshrc"
link "$DF/zsh/.zshenv"            "$HOME/.zshenv"
link "$DF/zsh/.zprofile"          "$HOME/.zprofile"
link "$DF/zsh/.profile"           "$HOME/.profile"
link "$DF/zsh/.p10k.zsh"          "$HOME/.p10k.zsh"
link "$DF/tmux/.tmux.conf"        "$HOME/.tmux.conf"
link "$DF/wezterm/.wezterm.lua"   "$HOME/.wezterm.lua"
link "$DF/git/.gitconfig"         "$HOME/.gitconfig"
link "$DF/git/ignore"             "$HOME/.config/git/ignore"

echo ""
echo "Listo. Reinicia tu shell (exec zsh) para aplicar."
