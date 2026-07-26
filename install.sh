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

# tmux-resurrect no crea su carpeta solo; sin esto el auto-guardado falla en silencio
mkdir -p "$HOME/.tmux/resurrect"
echo "creado: ~/.tmux/resurrect (para tmux-resurrect/continuum)"

# k9s: los skins NO pueden ser symlinks (k9s no los sigue) -> se COPIA el skin activo.
# El comando `theme` sobrescribe theme.yaml con dark/light; aquí sembramos el inicial.
K9S_SKINS="$HOME/Library/Application Support/k9s/skins"
mkdir -p "$K9S_SKINS"
K9S_MODE="$(cat "$HOME/.config/theme-mode" 2>/dev/null || echo dark)"
cp -f "$DF/k9s/skins/$K9S_MODE.yaml" "$K9S_SKINS/theme.yaml"
echo "copiado: skin de k9s ($K9S_MODE) -> theme.yaml"
echo "nota k9s: pon 'skin: theme' bajo k9s.ui en config.yaml para activarlo"

echo ""
echo "Listo. Reinicia tu shell (exec zsh) para aplicar."
