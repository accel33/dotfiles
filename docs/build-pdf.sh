#!/usr/bin/env bash
# Regenera el PDF del cheatsheet a partir de cheatsheet.html (mismo formato de 1 columna).
# Uso:
#   ./build-pdf.sh                 -> genera en ~/Desktop/nvim_tmux_cheatsheet.pdf
#   ./build-pdf.sh /ruta/out.pdf   -> genera en la ruta que le pases
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML="$DIR/cheatsheet.html"
OUT="${1:-$HOME/Desktop/nvim_tmux_cheatsheet.pdf}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [ ! -x "$CHROME" ]; then
  echo "✗ No encuentro Google Chrome en $CHROME" >&2
  exit 1
fi

"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$OUT" "file://$HTML" 2>/dev/null

echo "✔ PDF generado en: $OUT"
