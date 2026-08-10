# Handoff de sesión — julio 2026 (k9s · tmux · LSP · buffers · repos Kambista)

> Resumen de todo lo que se hizo en esta sesión, para el próximo Claude (o para mí).
> Lee también [`../README.md`](../README.md) y [`THEME.md`](THEME.md). Los cambios de
> **dotfiles ya están commiteados** (`cf0d9d2` + `bc21779`). Lo de los repos de trabajo
> (Kambista) NO es dotfiles — es contexto.

---

## 1. Cambios en dotfiles (ya commiteados)

### Neovim
| Atajo | Qué |
|---|---|
| `<leader><leader>` | Alternar entre buffer actual y anterior (reemplazo de `Ctrl-^`) |
| `<leader>bm` | Buffers sin guardar (`:ls +`) |
| `<leader>fb` | Telescope: buffers abiertos |
| `<leader>sr` | Modo resize incremental (h/l ancho, j/k alto, repetible; otra tecla sale) |
| `gr` | Referencias LSP **directo** (se borran los defaults `grr/grn/gra/gri/grt` de nvim 0.11 que lo hacían ambiguo) |

- ~~**bufferline** en modo `buffers` (un tab por archivo, estilo VSCode).~~ **Revertido en ago 2026**: los tabs se acumulaban y confundían. Ahora `enabled = false` + `showtabline = 0` → arriba no aparece nada. Los buffers siguen abiertos (`<leader><leader>`, `<leader>fb`, `:ls +`).
- ~~**lualine** muestra ruta relativa (`path=1`).~~ **Ago 2026**: `path=0`, solo el nombre del archivo.
- **nvim-tree** resalta y sigue el archivo actual (`update_focused_file`).
- **mason**: `+jdtls` (Java) — ⚠️ necesita **JDK 21+** para arrancar (hay solo Java 13; falta `brew install --cask zulu21` + `JAVA_HOME`).

### tmux (regla: minúscula = window · MAYÚSCULA = resize pane)
| Tecla (prefix `Ctrl-a`) | Qué |
|---|---|
| `H` / `L` | Resize pane izq/der · `j`/`k` abajo/arriba |
| `h` / `l` | Window anterior / siguiente |
| `r` | Renombrar window · `R` reload config · `C` copy-mode |

- Splits (`\` `-`) heredan el cwd (`-c '#{pane_current_path}'`).
- ⚠️ Al aplicar: usar el `r` VIEJO (reload) una vez; después reload es `R`.

### k9s (nuevo — `k9s/skins/`)
- Skins `dark.yaml` (Tokyo Night) y `light.yaml` (Flexoki).
- **k9s NO sigue symlinks** para skins → se **copian** (no `link`).
- `config.yaml` usa `ui.skin: theme`; el comando `theme` sobrescribe `theme.yaml` con dark/light y k9s recarga en vivo. Integrado a `theme 1/2`.

### docs / config
- `docs/cheatsheet.html` + `nvim_tmux_cheatsheet.pdf` actualizados (atajos nuevos).
- `docs/lazygit-cheatsheet.md` nuevo.
- `git/ignore`: `.DS_Store`, `._*`, `__MACOSX/`, `node_modules/`.
- `wezterm`: `window_close_confirmation = NeverPrompt`.
- Herramientas globales: **prettier** en node v24 + `~/.nvm/default-packages` (prettier, tsgo, tree-sitter-cli).

---

## 2. Repos de Kambista (contexto, NO dotfiles)

- **ESLint = por proyecto, NUNCA global en `~/Code`** (un config ahí se cuela en TODOS los subproyectos de trabajo y rompe). `@types/node` sí puede ir en `~/Code` (los tipos solo ayudan, no rompen).
- **`~/Code/uncc-code`** (curso Node): eslint local instalado; `files/promesas.js` con fixes de `fs.read`/nombre/await. Va por: binario→buffers→archivos→**streams**→http/net. Guía en `uncc-code/BUENAS-PRACTICAS.md` + bitácora en `uncc-code/files/README.md`.
- **`k-web/backend/identity-validation`**: le faltaban deps (`eslint-config-standard` + plugins) — instaladas con **pnpm**. Sin commitear a mezclar con `feature/fix-dni-extractor` (va en su rama).
- **`k-admin`**: monorepo, cada servicio con su tsconfig. **tsgo (TS7) rechaza `baseUrl`** → el LSP se degrada. Fix retrocompatible verificado: `baseUrl: "./"` → `paths: { "*": ["./*"] }` (funciona en tsgo Y en tsc 5.9.3 de los compañeros). Es un PR al repo compartido.

---

## 3. Gotchas / lecciones técnicas de la sesión

- **prettier NO repara un `;` ya-ausente** en código ambiguo (respeta el AST); protege agregándolo mientras escribes. ESLint `no-unexpected-multiline` detecta el caso.
- **`fs.read()`** devuelve `{ bytesRead, buffer }` (objeto prototipo `null`); el contenido está en el `buffer` que pasaste.
- **`fs.watch`** vigila por inode → muere si el editor guarda con reemplazo (write-temp+rename). Editar en el sitio o `:set backupcopy=yes`.
- **Hoisting**: `function f(){}` se usa antes de su línea; `const f=()=>` no (TDZ). En TS falla al compilar, no en runtime.
- **npm** sube buscando `package.json` → un `npm install` "local" puede acabar en la carpeta padre. `npm init -y` primero.
- **`.gitignore` NO afecta lo ya trackeado** → `git rm --cached`.
- **git**: `revert` (commit que deshace) ≠ `reset` (mueve rama) ≠ `checkout` (solo mirar). Traer cambios de otro commit → **cherry-pick** (`c`→`v` en lazygit).
- **Windows** "Deletion of directory failed" al checkout = archivos **bloqueados** por un proceso (node/editor). Cerrar y reintentar / `checkout -f`.
- **k9s NO sigue symlinks** para skins (¡el bug de toda la saga del tema!).

---

## 4. Pendientes / follow-ups

- [ ] **Java LSP**: instalar `zulu21` + `export JAVA_HOME=$(/usr/libexec/java_home -v 21)` para que jdtls arranque.
- [ ] **k-admin**: PR migrando `baseUrl` → `paths` (retrocompatible) para desbloquear tsgo. Empezar por adispersion.
- [ ] **k-web**: PR aparte con las deps de eslint-config-standard (no mezclar con dni).
- [ ] `uncc-code/files/promesas.js`: `createFile` está definida DESPUÉS del `for await` que la usa → convertir a `function createFile(){}` (hoisting). *(código de práctica — solo si él lo pide)*.

---

## 5. Cómo trabajar conmigo (reglas guardadas en memoria)

- **NUNCA commitear/pushear** sin pedido explícito ("commitea"). "ya hazlo" ≠ permiso para commitear.
- **No editar código de aprendizaje** (uncc-code) salvo que lo pida; config y docs sí.
- Formato preferido: **info completa + reglas prácticas accionables + verificación empírica** (correr y mostrar salida real).
- **No usar workflows multi-agente** sin avisar el costo (consumen mucho token).
