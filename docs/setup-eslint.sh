#!/usr/bin/env bash
# Configura ESLint en el proyecto ACTUAL (córrelo desde la raíz del proyecto).
# Copia la plantilla de config e instala las dependencias con tu gestor.
#
# Uso:
#   cd /ruta/de/tu/proyecto
#   ~/dotfiles/docs/setup-eslint.sh
#
# Detecta el gestor de paquetes por el lockfile (pnpm / yarn / bun / npm).
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$DIR/eslint.config.example.js"
TARGET="eslint.config.mjs" # .mjs evita el warning de "type: module"

if [ ! -f "$TEMPLATE" ]; then
  echo "✗ No encuentro la plantilla en $TEMPLATE" >&2
  exit 1
fi

# no sobreescribir si el proyecto ya tiene una config de ESLint
for f in eslint.config.js eslint.config.mjs eslint.config.cjs eslint.config.ts \
         .eslintrc .eslintrc.js .eslintrc.cjs .eslintrc.json .eslintrc.yaml .eslintrc.yml; do
  if [ -e "$f" ]; then
    echo "✗ Este proyecto ya tiene config de ESLint ($f). No toco nada." >&2
    exit 1
  fi
done

# detectar gestor de paquetes por el lockfile
if [ -f pnpm-lock.yaml ]; then
  PM="pnpm add -D"
elif [ -f yarn.lock ]; then
  PM="yarn add -D"
elif [ -f bun.lockb ] || [ -f bun.lock ]; then
  PM="bun add -d"
else
  PM="npm install -D"
fi

echo "→ Copiando plantilla a ./$TARGET"
cp "$TEMPLATE" "$TARGET"

echo "→ Instalando dependencias con: $PM"
$PM eslint @eslint/js typescript-eslint globals

echo ""
echo "✔ ESLint configurado en $(pwd)/$TARGET"
echo "  Reinicia Neovim (:qa y reabrir) — el LSP de eslint se activará en este proyecto."
