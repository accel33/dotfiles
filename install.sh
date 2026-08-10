#!/usr/bin/env bash
# Crea los symlinks de los dotfiles hacia sus ubicaciones esperadas.
# Uso: ./install.sh
set -e
DF="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local bak="$dst.bak.$(date +%s)"
    mv "$dst" "$bak"
    echo "backup: $dst -> $bak"
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

# Modo de tema inicial (dark|light). nvim/wezterm/tmux lo leen; el comando
# `theme` lo cambia. Solo se siembra si no existe (no pisar la elección actual).
if [ ! -f "$HOME/.config/theme-mode" ]; then
  mkdir -p "$HOME/.config"
  echo dark > "$HOME/.config/theme-mode"
  echo "creado: ~/.config/theme-mode (dark)"
fi

# tmux-resurrect no crea su carpeta solo; sin esto el auto-guardado falla en silencio
mkdir -p "$HOME/.tmux/resurrect"
echo "creado: ~/.tmux/resurrect (para tmux-resurrect/continuum)"

# tpm (plugin manager de tmux): sin él, .tmux.conf no carga ningún plugin.
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "clonado: tpm -> ~/.tmux/plugins/tpm (dentro de tmux: prefix + I instala los plugins)"
fi

# k9s: los skins NO pueden ser symlinks (k9s no los sigue) -> se COPIA el skin activo.
# El comando `theme` sobrescribe theme.yaml con dark/light; aquí sembramos el inicial.
K9S_DIR="$HOME/Library/Application Support/k9s"
K9S_SKINS="$K9S_DIR/skins"
mkdir -p "$K9S_SKINS"
K9S_MODE="$(cat "$HOME/.config/theme-mode" 2>/dev/null || echo dark)"
cp -f "$DF/k9s/skins/$K9S_MODE.yaml" "$K9S_SKINS/theme.yaml"
echo "copiado: skin de k9s ($K9S_MODE) -> theme.yaml"
# Activar el skin: config.yaml debe tener ui.skin = theme. Si no hay config.yaml
# (máquina nueva), sembramos uno mínimo (k9s completa el resto al arrancar).
# Si YA existe, no lo tocamos: revisa a mano que tenga  skin: theme  bajo k9s.ui.
if [ ! -f "$K9S_DIR/config.yaml" ]; then
  printf 'k9s:\n  ui:\n    skin: theme\n' > "$K9S_DIR/config.yaml"
  echo "creado: config.yaml de k9s con ui.skin=theme"
else
  grep -q "skin: theme" "$K9S_DIR/config.yaml" \
    && echo "k9s: config.yaml ya tiene skin: theme ✓" \
    || echo "⚠ k9s: agrega 'skin: theme' bajo k9s.ui en $K9S_DIR/config.yaml"
fi

echo ""
echo "Listo. Reinicia tu shell (exec zsh) para aplicar."
