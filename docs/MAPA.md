# Mapa de los dotfiles — qué es cada archivo y cómo funciona todo

> Guía simple: qué hay en cada archivo, cómo se conectan, y qué pasa cuando
> levantas una máquina nueva. Los comandos exactos de instalación viven en el
> [README](../README.md#-instalación-en-una-máquina-nueva); la letra chica en
> sus [gotchas](../README.md#%EF%B8%8F-gotchas--lecciones-aprendidas-leer).

---

## 💡 La idea en un minuto

Este repo es la **fuente de verdad** de toda la configuración. Ningún programa
lee este repo directamente: [`install.sh`](../install.sh) crea **symlinks**
desde las rutas que cada app espera hacia los archivos de aquí:

| La app lee… | …que es un symlink a |
|---|---|
| `~/.config/nvim/` | `~/dotfiles/nvim/` |
| `~/.zshrc` `.zshenv` `.zprofile` `.profile` `.p10k.zsh` | `~/dotfiles/zsh/…` |
| `~/.tmux.conf` | `~/dotfiles/tmux/.tmux.conf` |
| `~/.wezterm.lua` | `~/dotfiles/wezterm/.wezterm.lua` |
| `~/.gitconfig` y `~/.config/git/ignore` | `~/dotfiles/git/…` |
| skins de k9s | **copia** (no symlink: k9s no los sigue — gotcha real) |

Consecuencia: **editas un archivo del repo → la app ya ve el cambio** (tras
recargar esa app). Y todo queda versionado en git.

---

## 📄 Qué es cada cosa

### Raíz

| Archivo | Qué es |
|---|---|
| [`install.sh`](../install.sh) | El instalador. Crea todos los symlinks (con backup si había un archivo real), siembra `~/.config/theme-mode`, clona tpm si falta, crea `~/.tmux/resurrect` y copia el skin de k9s. **Idempotente**: correrlo de nuevo no rompe nada. |
| [`Brewfile`](../Brewfile) | TODO el software: fórmulas de brew, casks (apps), extensiones de VSCode y paquetes npm globales. Se instala completo con `brew bundle install`. |
| [`README.md`](../README.md) | Visión general + instalación en máquina nueva + los **gotchas** (lecciones aprendidas a golpes — léelos antes de tocar temas/tmux/treesitter). |
| `nvim_tmux_cheatsheet.pdf` | El cheatsheet generado (copia versionada; el "oficial" va a `~/Desktop`). |

### `nvim/` — Neovim (leader = Espacio)

| Ruta | Qué hace |
|---|---|
| `init.lua` | Solo 2 requires: carga `core` y luego `lazy` (plugins). |
| `lua/accel/core/options.lua` | Opciones del editor: números relativos, tabs=2, clipboard al sistema, splits, `showtabline=0` (sin barra de tabs arriba), silenciador de avisos de deprecación de plugins. |
| `lua/accel/core/keymaps.lua` | Atajos generales: `kj`/`jk` para salir de insert, portapapeles inteligente (solo `y` copia; `d/c/x` van al black hole), splits, `<leader>sr` resize incremental, y el mapeo especial de `g` que hace `gr` = referencias LSP sin timeout. |
| `lua/accel/lazy.lua` | Bootstrap de lazy.nvim (se auto-instala si falta) e importa todo `plugins/`. |
| `lua/accel/plugins/*.lua` | **Un archivo = un plugin.** Los importantes: `colorscheme` (tokyonight oscuro / flexoki claro según `theme-mode` + fix del separador de nvim-tree), `telescope` (buscar — necesita `fd` y `ripgrep`), `nvim-tree` (árbol de archivos), `lualine` (barra inferior, solo nombre del archivo), `bufferline` (**desactivado** — sin tabs arriba), `treesitter` (resaltado; rama main + parser tmux re-registrado a mano), `formatting` (prettier/stylua/google-java-format al guardar), `gitsigns`+`lazygit` (git), `trouble` (panel de errores), `nvim-cmp` (autocompletado), `auto-session` (sesiones por carpeta). |
| `lua/accel/plugins/lsp/` | `mason` (instala los language servers), `lspconfig` (config de cada LSP: tsgo/ts_ls para TypeScript, lua_ls, y el **gate de eslint**: solo se activa si el proyecto tiene config de eslint), `jdtls` (declara los plugins de Java). |
| `ftplugin/java.lua` | Arranque especial de Java (jdtls) por cada buffer `.java` — Java no usa el flujo LSP normal. Ver [`JAVA.md`](JAVA.md). |
| `queries/tmux/` | Queries de treesitter para resaltar `.tmux.conf` (el parser de tmux lo dropearon upstream; lo mantenemos nosotros — gotcha #11). |
| `lazy-lock.json` | Versiones exactas de cada plugin (como un package-lock). Se versiona para que otra máquina instale LO MISMO. |

### `tmux/` — multiplexor (prefix = Ctrl+a)

| Archivo | Qué hace |
|---|---|
| `.tmux.conf` | Prefix `C-a`, splits `\` y `-` (heredan carpeta), resize con mayúsculas `H/L/j/k`, ventanas con `h/l`, copy-mode estilo vim → portapapeles de macOS, mouse ON, y los plugins: vim-tmux-navigator (`C-h/j/k/l` entre nvim y tmux), resurrect + continuum (sesiones sobreviven reinicios, auto-guardado cada 15 min), tmux-power (barra oscura). Al final: si el tema es claro, carga la barra clara con 1s de delay (gotcha #3). |
| `theme-light.conf` | La barra CLARA (flexoki teal) construida a mano con glifos powerline en bytes (gotcha #6). |

### `wezterm/` — la terminal

`.wezterm.lua`: fuente MesloLGS Nerd Font 19, esquema según `theme-mode`
(Tokyo Night / flexoki-light definido inline), teclas estilo macOS (`⌥←/→`,
`⌘←/→`, `⌘⌫`), `⌘⏎` maximizar/restaurar, y la **barra superior integrada**:
sin barra de título del sistema; los "puntitos" de mac son dibujados por
nosotros en el status de la tab bar (la historia completa de por qué así está
comentada dentro del archivo — 4 intentos).

### `zsh/` — la shell

| Archivo | Qué hace |
|---|---|
| `.zshrc` | oh-my-zsh + powerlevel10k (instant prompt), autosuggestions + syntax-highlighting (de brew), historial compartido, `ls`=eza, `cd`=zoxide (al FINAL del archivo, lo exige), aliases propios (`vim`→nvim, `theme`, `cheatsheet`, `eslint-init`), nvm, pnpm, JAVA_HOME → openjdk@21, gcloud con python3.10. |
| `.p10k.zsh` | El prompt (generado por `p10k configure`; no se edita a mano). |
| `.zshenv` / `.zprofile` / `.profile` | Mini-archivos de entorno: cargo (Rust) y brew shellenv. |

### `git/`, `k9s/`, `docs/`

| Ruta | Qué hace |
|---|---|
| `git/.gitconfig` | Identidad + credenciales vía `gh` + git-lfs. |
| `git/ignore` | Ignore GLOBAL (todo repo): `.DS_Store`, `node_modules/`, etc. |
| `k9s/skins/` | Skins dark (Tokyo Night) y light (Flexoki). Se **copian** a `~/Library/Application Support/k9s/skins/theme.yaml`; `config.yaml` de k9s debe tener `ui.skin: theme` (install.sh lo siembra si no existe). |
| `docs/theme.sh` | El comando `theme`: cambia día/noche en nvim + WezTerm + tmux + k9s a la vez. Ver [`THEME.md`](THEME.md). |
| `docs/cheatsheet.html` + `build-pdf.sh` | Fuente y generador del cheatsheet PDF (`cheatsheet` = oscuro, `cheatsheet --light` = claro; imprime con Chrome headless). |
| `docs/setup-eslint.sh` + `eslint.config.example.js` | El comando `eslint-init`: instala eslint POR PROYECTO (nunca global — gotcha #8). |
| `docs/JAVA.md` / `THEME.md` / `HANDOFF.md` / `lazygit-cheatsheet.md` | Cómo quedó montado Java · el sistema de temas · notas de la última sesión · teclas de lazygit. |

---

## 🌗 El sistema de temas en 20 segundos

Un solo archivo manda: **`~/.config/theme-mode`** (contiene `dark` o `light`).

```
theme 1|2  ──escribe──►  ~/.config/theme-mode
                              │
        ┌─────────────┬───────┴──────┬──────────────┐
        ▼             ▼              ▼              ▼
      nvim         WezTerm         tmux           k9s
  (colorscheme   (color_scheme   (barra power   (theme.yaml
   al arrancar)   + touch para    o light.conf)  sobrescrito)
                  recargar)
```

Cada app lo lee al arrancar/recargar; `theme.sh` además empuja el cambio a las
apps abiertas. Detalles y trampas: [`THEME.md`](THEME.md).

---

## 🚀 Máquina nueva: qué hace cada paso

Los comandos exactos están en el [README](../README.md#-instalación-en-una-máquina-nueva).
Esto es el **por qué** de cada paso y su orden:

1. **Homebrew** — el gestor de todo lo demás. Sin él no hay paso 5.
2. **nvm + node LTS** — va ANTES del Brewfile porque el Brewfile incluye
   paquetes `npm` globales y necesita un node ya presente.
3. **`~/.nvm/default-packages`** — lista de globales (tsgo, tree-sitter-cli,
   prettier) que cada versión NUEVA de node instala sola. Sin esto, cambias de
   node y nvim pierde prettier (gotcha #10).
4. **oh-my-zsh** — framework del `.zshrc`. Se instala antes de los symlinks
   para que no pise nuestro `.zshrc` (deja el suyo, install.sh lo reemplaza).
5. **`git clone` + `brew bundle` + `./install.sh`** — el clone trae la config;
   bundle instala TODO el software (brew/casks/npm/vscode — Chrome incluido,
   se "adopta" si ya existía); install.sh enlaza todo y siembra lo que falta
   (theme-mode, tpm, carpeta de resurrect, skin de k9s).
6. **Dentro de las apps** — nvim instala sus plugins solo al abrir (lazy lee
   `lazy-lock.json` → versiones exactas); en tmux `prefix + I` (tpm ya está
   clonado); Java no necesita nada extra (openjdk@21 viene del Brewfile y
   mason instala jdtls solo).

Verificación rápida al final (también en el README): `checkhealth` de nvim,
`java -version`, una sesión de tmux, y `cheatsheet` para el PDF.

---

*¿Algo se comporta raro después de instalar? Los
[gotchas del README](../README.md#%EF%B8%8F-gotchas--lecciones-aprendidas-leer)
existen porque ya nos pasó: recargas que no recargan, SIGUSR1 que mata WezTerm,
skins que no siguen symlinks, parsers dropeados…*
