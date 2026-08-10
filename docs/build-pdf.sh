#!/usr/bin/env bash
# Regenera el PDF del cheatsheet a partir de cheatsheet.html (mismo formato de 1 columna).
#
# Uso:
#   ./build-pdf.sh                  -> OSCURO (default) en ~/Desktop/nvim_tmux_cheatsheet.pdf
#   ./build-pdf.sh --light          -> CLARO, en ~/Desktop/nvim_tmux_cheatsheet-light.pdf
#   ./build-pdf.sh /ruta/out.pdf    -> oscuro en la ruta que le pases
#   ./build-pdf.sh --light /ruta/out.pdf
#
# El tema lo elige el propio HTML leyendo el fragmento de la URL (#dark / #light);
# por eso aquí solo se lo pasamos pegado al file://. Ver el <script> de cheatsheet.html.
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML="$DIR/cheatsheet.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

MODE=dark
OUT=""
for arg in "$@"; do
  case "$arg" in
    --light | -l | light) MODE=light ;;
    --dark | -d | dark) MODE=dark ;;
    -h | --help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *) OUT="$arg" ;;
  esac
done

if [ -z "$OUT" ]; then
  if [ "$MODE" = light ]; then
    OUT="$HOME/Desktop/nvim_tmux_cheatsheet-light.pdf"
  else
    OUT="$HOME/Desktop/nvim_tmux_cheatsheet.pdf"
  fi
fi

if [ ! -x "$CHROME" ]; then
  echo "✗ No encuentro Google Chrome en $CHROME" >&2
  exit 1
fi

"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT" "file://$HTML#$MODE" 2>/dev/null

echo "✔ PDF ($MODE) generado en: $OUT"
