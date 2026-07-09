// ─────────────────────────────────────────────────────────────────────────────
// Plantilla de ESLint (flat config, ESLint v9+) — sirve para JavaScript Y TypeScript
//
// CÓMO USARLA en un proyecto:
//   1) Copia este archivo a la raíz del proyecto como  eslint.config.js
//   2) Instala las dependencias:
//        npm i -D eslint @eslint/js typescript-eslint globals
//      (o el equivalente con pnpm/yarn:  pnpm add -D ...   /   yarn add -D ...)
//   3) Reinicia Neovim -> el LSP de eslint se activará solo al detectar este archivo.
//
// Si el proyecto es SOLO JavaScript (sin TypeScript), igual funciona: typescript-eslint
// lintea archivos .js sin problema. Si quieres una versión sin TS, borra las líneas
// marcadas con  // [TS].
// ─────────────────────────────────────────────────────────────────────────────

import js from "@eslint/js";
import tseslint from "typescript-eslint"; // [TS]
import globals from "globals";

export default tseslint.config(
  // reglas recomendadas base de ESLint
  js.configs.recommended,

  // reglas recomendadas de TypeScript (quítalo si es proyecto solo-JS)
  ...tseslint.configs.recommended, // [TS]

  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.node, // process, console, __dirname, etc.
        ...globals.browser, // window, document, fetch, etc. (borra si es solo backend)
      },
    },
    rules: {
      // --- calidad / posibles errores ---
      "prefer-const": "warn", // usa const si no reasignas
      eqeqeq: ["warn", "smart"], // usa === en vez de ==
      "no-var": "warn", // nada de var, usa let/const

      // unused vars: dejamos que lo maneje la versión TS-aware (ignora args con _)
      "no-unused-vars": "off",
      "@typescript-eslint/no-unused-vars": ["warn", { argsIgnorePattern: "^_" }], // [TS]

      // --- estilo (ajústalo a tu gusto) ---
      "no-console": "off", // pon "warn" si no quieres console.log en producción
    },
  },

  // carpetas/archivos que ESLint debe ignorar
  {
    ignores: ["dist/", "build/", "coverage/", "node_modules/", "*.min.js"],
  }
);
