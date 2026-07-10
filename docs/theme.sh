#!/usr/bin/env bash
# Cambia el tema de Neovim + WezTerm JUNTOS con un comando.
#   theme            -> alterna entre claro/oscuro
#   theme 1 | dark   -> oscuro (Tokyo Night)
#   theme 2 | light  -> claro  (Flexoki)
# Aplica al instante a los nvim abiertos y a WezTerm, y persiste para lo que abras después.
# (tmux mantiene su propia barra tmux-power; no lo toca.)
set -e

STATE="$HOME/.config/theme-mode"
current="$(cat "$STATE" 2>/dev/null || echo dark)"

case "${1:-toggle}" in
  1 | dark | d) MODE=dark ;;
  2 | light | l) MODE=light ;;
  toggle) [ "$current" = light ] && MODE=dark || MODE=light ;;
  *) echo "uso: theme [ 1|dark | 2|light ]   (sin argumento alterna)"; exit 1 ;;
esac

# 1) guardar el estado (lo leen nvim y tmux al iniciar)
mkdir -p "$(dirname "$STATE")"
echo "$MODE" >"$STATE"

# 2) nvim: colorscheme + background según el modo
if [ "$MODE" = light ]; then
  NVIM_CS="flexoki-light"; NVIM_BG="light"
else
  NVIM_CS="tokyonight-night"; NVIM_BG="dark"
fi
# aplicar a los nvim YA ABIERTOS (vía sus sockets, sin interrumpir lo que escribes)
for sock in $(find "${TMPDIR:-/tmp}" -maxdepth 3 -name 'nvim.*.0' -type s 2>/dev/null); do
  nvim --server "$sock" --remote-expr \
    "execute('set background=$NVIM_BG | colorscheme $NVIM_CS')" >/dev/null 2>&1 || true
done

# 3) WezTerm: cambia color_scheme (fondo del terminal). WezTerm lee ~/.config/theme-mode
#    al cargar su config; con `touch` forzamos que recargue y aplique el nuevo esquema.
touch "$HOME/dotfiles/wezterm/.wezterm.lua" 2>/dev/null || true

echo "✔ tema: $MODE  (nvim: $NVIM_CS · WezTerm: fondo $MODE)"
