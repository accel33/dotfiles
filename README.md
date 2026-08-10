# dotfiles — accel

Configuración personal de macOS: **Neovim + tmux + WezTerm + zsh**, gestionada con symlinks y versionada en GitHub (`accel33/dotfiles`).

> **🗺️ ¿Qué es cada archivo y cómo funciona todo?** → [`docs/MAPA.md`](docs/MAPA.md) (incluye el flujo de máquina nueva explicado).
>
> **🤖 Para la próxima sesión de Claude (o para mí):** este README + [`docs/THEME.md`](docs/THEME.md) resumen TODO lo montado. Lee primero la sección **"Gotchas / lecciones aprendidas"** — hay varias trampas (recargas, SIGUSR1 que mata WezTerm, glyphs powerline, treesitter main, etc.) que costó descubrir. La config real vive en este repo; explórala libremente.

---

## 📁 Estructura

```
~/dotfiles/
├── install.sh              # symlinks + theme-mode + tpm + ~/.tmux/resurrect + skin k9s (idempotente)
├── Brewfile                # todo el software (brew bundle install)
├── nvim/                   # → ~/.config/nvim   (Neovim, lua/accel)
├── zsh/                    # → ~   (.zshrc .zshenv .zprofile .profile .p10k.zsh)
├── tmux/                   # .tmux.conf + theme-light.conf  → ~
├── wezterm/                # .wezterm.lua  → ~
├── git/                    # .gitconfig + ignore global
├── k9s/                    # skins de k9s (dark/light) → se COPIAN a ~/Library/…/k9s/skins (k9s no sigue symlinks)
└── docs/                   # scripts y plantillas (ver abajo)
    ├── theme.sh            # comando `theme` (día/noche: nvim+wezterm+tmux)
    ├── setup-eslint.sh     # instala eslint en el proyecto actual
    ├── build-pdf.sh        # regenera el PDF del cheatsheet (OSCURO por defecto; --light para el claro)
    ├── cheatsheet.html     # fuente del cheatsheet (nvim+tmux+terminal); el tema lo elige #dark/#light
    ├── lazygit-cheatsheet.md    # teclas y conceptos de git + lazygit
    ├── THEME.md            # cómo funciona el sistema de temas día/noche
    ├── JAVA.md             # cómo quedó montado Java (jdtls) en Neovim
    ├── HANDOFF.md          # notas de la última sesión (contexto para el próximo Claude/tú)
    ├── MAPA.md             # 🗺️ qué es cada archivo, cómo se conecta todo, flujo de máquina nueva
    └── eslint.config.example.js  # plantilla de eslint (JS/TS)
```

## 🚀 Instalación en una máquina nueva

Secuencia completa y EN ESTE ORDEN (el Brewfile trae entradas `npm`, así que
node/nvm van antes del bundle):

```bash
# 1) Homebrew (si la máquina no lo tiene)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2) nvm + node LTS (el bundle instala paquetes npm; necesita node ya presente)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
\. "$HOME/.nvm/nvm.sh" && nvm install --lts

# 3) que cada versión nueva de node traiga las herramientas globales sola (gotcha #10)
printf '%s\n' @typescript/native-preview tree-sitter-cli prettier > ~/.nvm/default-packages

# 4) oh-my-zsh (deja el .zshrc por defecto; el nuestro lo enlaza install.sh después)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 5) el repo + todo el software + symlinks
git clone git@github.com:accel33/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle install --file=Brewfile   # brew + casks + npm globales (Chrome se "adopta" si ya existe)
./install.sh                          # symlinks · theme-mode · tpm · resurrect · skin k9s
exec zsh
```

Después, dentro de las apps:
- **nvim**: al abrirlo, lazy instala los plugins solo (o `:Lazy sync`); los parsers de treesitter se compilan con el CLI `tree-sitter` (ya viene del default-packages).
- **tmux**: `prefix + I` para que tpm instale los plugins (tpm ya lo clonó install.sh).
- **Java**: nada extra — `openjdk@21` viene en el Brewfile y jdtls/mason se instalan solos (ver [`docs/JAVA.md`](docs/JAVA.md)).

Verificación rápida de que todo quedó:
```bash
nvim --headless "+checkhealth vim.lsp" +qa   # sin errores de LSP
tmux new -s test                             # barra con tema; Ctrl+a I si faltan plugins
java -version                                # openjdk 21.x
cheatsheet                                   # regenera el PDF (usa Chrome headless)
```

### 📦 `@types/node` en la carpeta padre de tus proyectos (autocompletado de Node)

TypeScript/tsgo busca los tipos **subiendo por el árbol de carpetas**: incluye los `@types` que encuentre en el `node_modules/@types` de **cualquier carpeta superior** al archivo que editas. Aprovechando eso, si instalas `@types/node` **una sola vez en la carpeta que contiene todos tus proyectos**, TODOS heredan el autocompletado de los módulos de Node (`fs`, `path`, `os`…) sin instalarlo proyecto por proyecto.

```bash
cd ~/Code && npm i @types/node        # ~/Code es el default/ideal
```

- **No tiene que ser `~/Code`**: hazlo en el **ancestro común** donde vivan tus repos (ej. `~/dev`, `~/proyectos`). Lo ideal es mantener todo bajo una sola carpeta (`~/Code`) para que baste un install.
- Si trabajas en varias carpetas raíz distintas, repite el `npm i @types/node` en cada una.
- ⚠️ **ESLint NO se pone en `~/Code`** (aunque `@types/node` sí): una config de eslint en la carpeta padre se cuela en TODOS los proyectos de abajo — incluidos los de trabajo (kambista, k-admin…) — y les mete reglas ajenas o rompe por choque de versiones. ESLint va **por proyecto** (`eslint-init`). Ver gotcha #8.

## ⚙️ Aliases y comandos propios (en `.zshrc`)

| Comando | Qué hace |
|---|---|
| `theme 1` / `theme 2` / `theme` | **Día/noche**: cambia nvim + WezTerm + tmux + k9s juntos (1=oscuro, 2=claro, sin arg alterna). Ver [`docs/THEME.md`](docs/THEME.md) |
| `eslint-init` | Instala eslint en el proyecto actual (copia plantilla + deps) |
| `cheatsheet` | Regenera `~/Desktop/nvim_tmux_cheatsheet.pdf` (**tema oscuro**, Tokyo Night) desde `docs/cheatsheet.html`. `cheatsheet --light` genera la versión clara en `…-light.pdf` |
| `vim` | → `nvim` · `denos` → deno con permisos env/net |

---

## 🧠 Neovim (v0.12, base josean-dev, muy modificado)

- **Leader = Espacio.** Estructura en `nvim/lua/accel/` (core: options/keymaps; plugins/*).
- **TypeScript = `tsgo`** (TypeScript 7 nativo en Go, `@typescript/native-preview`). Toggle a `ts_ls` con `use_tsgo` en `plugins/lsp/lspconfig.lua`. `ts_ls` excluido del auto-enable de mason para no correr dos servidores.
- **treesitter en rama `main`** (la `master` está EOL para 0.12). **Requiere el CLI `tree-sitter`** (npm) para compilar parsers. Highlight se arranca por buffer con `vim.treesitter.start()` en autocmd FileType.
- **ESLint**: el LSP solo se activa si encuentra config subiendo por el árbol (gate en `root_dir`). Config **por proyecto** con `eslint-init` (config + deps locales). **No usar config global en `~/Code`** — se cuela en los proyectos de trabajo (ver gotcha #8). `eslint_d` quitado de nvim-lint.
- **Colorschemes**: tokyonight (oscuro, default), **flexoki-light** (claro), kanagawa, catppuccin, rose-pine. El colorscheme lo decide `~/.config/theme-mode` (ver THEME.md).
- **lualine** `theme="auto"` → sigue el tema (oscuro/claro) automáticamente.
- **Portapapeles**: `unnamedplus`; solo `y` (yank) va al portapapeles; `d/c/x` van al "black hole"; `<leader>d` = cortar al portapapeles; en visual `p` no pisa el yank.
- **nvim-cmp** estilo VSCode: `Tab`/`S-Tab` ciclan + saltan snippets, `Enter`/`C-y` confirman, `C-j/C-k`/flechas/`C-n/C-p` navegan.
- **Otros**: hover `K` con borde; `C-s` signature help; inlay hints OFF por defecto (`<leader>ih` toggle); comentarios `gcc`/`gc`/`<leader>/`; sin auto-continuar comentarios; sin terminal interna (se usa un pane de tmux).

## 🖥️ tmux

- **Prefix = `Ctrl+a`.** Splits `v` (vertical) / `-` (horizontal). Resize `h/j/k/l` (repetible). Zoom `m`. Copiar: copy-mode `y` → `pbcopy`. Mouse ON. Windows/panes empiezan en 1.
- **Navegación nvim↔tmux**: `Ctrl+h/j/k/l` (vim-tmux-navigator).
- **Sesiones persistentes**: resurrect + continuum (auto-guarda cada 15 min, restaura al reiniciar). Requiere que exista `~/.tmux/resurrect` (lo crea `install.sh`).
- **Barra**: noche = **tmux-power** (teal colour6); día = barra flexoki teal propia (`tmux/theme-light.conf`). Ver THEME.md.

## 🐚 zsh + ✨ WezTerm

- **zsh**: oh-my-zsh + powerlevel10k (marco `%6F` cian = color del reloj; transient prompt). `cd`=zoxide, `ls`=eza. `Ctrl+Espacio` acepta la autosugerencia (también `→`/`C-F`/`C-E`). `Ctrl+P` comando anterior; `!!` último comando. gcloud usa `CLOUDSDK_PYTHON=python3.10`.
- **WezTerm**: MesloLGS Nerd Font 19, Tokyo Night. **Teclas estilo macOS**: `⌥←/→` salta palabra, `⌘←/→` inicio/fin de línea, `⌘⌫` borra línea, `⌥⌫` borra palabra. Lee `~/.config/theme-mode` para el color scheme.
- **Barra de título integrada** (ago 2026): sin barra de título nativa; los 3 botones de macOS van dentro de la barra de la app, pintada del mismo color que el terminal (`#1a1b26` de noche, `#FFFCF0` de día) → se ve como una sola pieza. Son 6 opciones que dependen entre sí (`INTEGRATED_BUTTONS` necesita la tab bar encendida, y `hide_tab_bar_if_only_one_tab` debe quedar en `false` o desaparecen los botones); están comentadas en [`wezterm/.wezterm.lua`](wezterm/.wezterm.lua). ⚠️ Como la barra no muestra pestañas, un `⌘t` de WezTerm abriría una pestaña **invisible**: las pestañas van por tmux (`prefix + c`).

---

## ⚠️ Gotchas / lecciones aprendidas (LEER)

1. **Cambios de config requieren reiniciar esa app.** La instancia abierta usa la config vieja. `:qa`+reabrir nvim; `Ctrl+a r` o reiniciar tmux; WezTerm recarga al guardar. **El detach/attach de tmux NO reinicia nada.**
2. **NUNCA mandar `SIGUSR1` a WezTerm** → lo **cierra** (no lo recarga). Para recargarlo: `touch` a `~/.wezterm.lua` (tarda ~1s, seguro).
3. **tmux-power carga async** (vía tpm) → gana carreras al arrancar. Por eso la barra clara se aplica con un **delay** (`sleep 1`) en `.tmux.conf`.
4. **tmux renderiza el fondo de la barra con la opción vieja `status-bg`**, no solo `status-style` → hay que setear **ambas**.
5. **continuum** (auto-guardado) depende de su hook en `status-right` → re-inyectar con `set -ag status-right` tras cambiar la barra; continuum debe cargar DESPUÉS de los temas.
6. **Glyphs powerline** ` ` = bytes `\xee\x82\xb0` / `\xee\x82\xb2`. Se pierden al escribir/`tmux show` → construir con `printf`/heredoc usando los bytes (ver `tmux/theme-light.conf` y THEME.md).
7. **treesitter main** necesita el CLI `tree-sitter` para compilar parsers.
8. **ESLint va POR PROYECTO, nunca global en `~/Code`** (confirmado en vivo 2026-07-11). Una `eslint.config.mjs` en `~/Code` se cuela por el `root_dir` (busca upward) en TODOS los subproyectos, incluidos los de trabajo sin config propia (ej. k-admin). Ahí rompe con `Could not find "no-unassigned-vars" in plugin "@"`: el preset `@eslint/js` v10 referencia una regla nueva que el eslint **bundled del language server (Mason, más viejo)** no tiene. Con config **local** el LSP usa el eslint local (versión que coincide) → sin choque. Regla: config + `node_modules` dentro del proyecto (`eslint-init`).
9. **El teal de flexoki que combina con lualine es `#24837b`** (no el olivo `#66800b`).
10. **prettier (conform) es por-versión-de-node con nvm.** `npm i -g prettier` solo lo instala en la versión ACTIVA (`nvm current`). Si lanzas nvim desde otra versión, conform no lo halla → cae al LSP, que **no agrega `;`** → riesgo de bug ASI (ej. `require("x")` pegado a `(async...)`). Fix: prettier vive en `~/.nvm/versions/node/<ver>/bin`; ya está en `~/.nvm/default-packages` para que toda nueva versión lo traiga. Nota: prettier NO repara un `;` faltante ya escrito (respeta el AST parseado); protege porque el format-on-save lo agrega mientras escribes, antes de que se forme la ambigüedad.
11. **El parser treesitter de `tmux` lo dropeó nvim-treesitter (rama main).** Se
    re-registra a mano en `treesitter.lua` (grammar `Freed-Wu/tree-sitter-tmux` fija +
    `generate=true`) vía el autocmd `User TSUpdate` que dispara su `reload_parsers()`
    (una mutación directa no sobrevive a esa recarga). Las queries van versionadas en
    `nvim/queries/tmux/`. Resultado: sin warning y el parser se recompila solo en una
    máquina nueva. Verificado (build limpio + resaltado). Mismo patrón sirve para
    cualquier otro parser que dropeen en el futuro.
12. **PDF a sangre (fondo oscuro que llega al borde del papel).** Chrome **recorta todo
    lo que pintas al área de contenido**: con `@page{margin:14mm}` los márgenes salen
    BLANCOS pase lo que pase — ni el fondo de `html`, ni `position:fixed` con inset
    negativo (verificado: se recorta igual) llegan ahí, y `@page{background:…}` no
    existe en Chrome. Única salida: **`@page{margin:0}`** y poner el aire uno mismo.
    Pero entonces aparece el 2º problema: **Chrome DESCARTA el `margin-top` del bloque
    que cae al inicio de una página** en los saltos *automáticos* (sí lo respeta en los
    **forzados**, `page-break-before:always` — por eso las páginas de tmux/terminal sí
    tenían aire y las demás no). Solución en `cheatsheet.html`: envolver todo en una
    `<table class="sheet">` con un `<thead>`/`<tfoot>` que solo contienen un div de
    13mm — **thead y tfoot se repiten en CADA página impresa**, así que dan el margen
    superior e inferior en todas; el padding lateral va en el `<td>` del cuerpo (ese sí
    aplica por página). Verificado midiendo los content streams del PDF: las 9 páginas
    con fondo `#1a1b26` a sangre y ≥13mm de aire arriba.

## 📌 Pendientes / notas

- Conflicto `<leader>d`: es "cortar al portapapeles" (global) y "diagnóstico de línea" (LSP, buffer-local). En archivos con LSP gana el diagnóstico. Sin resolver.
- `{ name = "luasnip" }` está comentado en `nvim-cmp.lua` (decisión del usuario) → `Tab` ya no salta campos de snippet, solo cicla el menú.
- **Cheatsheet PDF**: `~/Desktop/nvim_tmux_cheatsheet.pdf` (regenerar con `cheatsheet`). Fuente: `docs/cheatsheet.html`. Desde 2026-08 sale en **oscuro** (Tokyo Night, el mismo fondo `#1a1b26` de nvim/WezTerm/k9s); `cheatsheet --light` da el claro. Ver gotcha #12 para el truco de los márgenes.
