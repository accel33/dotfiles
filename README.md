# dotfiles — accel

Configuración personal de macOS: **Neovim + tmux + WezTerm + zsh**, gestionada con symlinks y versionada en GitHub (`accel33/dotfiles`).

> **🤖 Para la próxima sesión de Claude (o para mí):** este README + [`docs/THEME.md`](docs/THEME.md) resumen TODO lo montado. Lee primero la sección **"Gotchas / lecciones aprendidas"** — hay varias trampas (recargas, SIGUSR1 que mata WezTerm, glyphs powerline, treesitter main, etc.) que costó descubrir. La config real vive en este repo; explórala libremente.

---

## 📁 Estructura

```
~/dotfiles/
├── install.sh              # crea todos los symlinks (y ~/.tmux/resurrect)
├── Brewfile                # todo el software (brew bundle install)
├── nvim/                   # → ~/.config/nvim   (Neovim, lua/accel)
├── zsh/                    # → ~   (.zshrc .zshenv .zprofile .profile .p10k.zsh)
├── tmux/                   # .tmux.conf + theme-light.conf  → ~
├── wezterm/                # .wezterm.lua  → ~
├── git/                    # .gitconfig + ignore global
└── docs/                   # scripts y plantillas (ver abajo)
    ├── theme.sh            # comando `theme` (día/noche: nvim+wezterm+tmux)
    ├── setup-eslint.sh     # instala eslint en el proyecto actual
    ├── build-pdf.sh        # regenera el PDF del cheatsheet
    ├── cheatsheet.html     # fuente del cheatsheet (nvim+tmux+terminal)
    └── eslint.config.example.js  # plantilla de eslint (JS/TS)
```

## 🚀 Instalación en una máquina nueva

```bash
git clone git@github.com:accel33/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle install --file=Brewfile        # todo el software
./install.sh                                # symlinks + ~/.tmux/resurrect
# extras que no maneja brew:
npm install -g @typescript/native-preview tree-sitter-cli   # tsgo + parsers de nvim
# oh-my-zsh: https://ohmyz.sh · tpm: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Luego: abre nvim (`:Lazy sync` instala plugins), y en tmux `prefix + I` (instala plugins con tpm).

### 📦 `@types/node` en la carpeta padre de tus proyectos (autocompletado de Node)

TypeScript/tsgo busca los tipos **subiendo por el árbol de carpetas**: incluye los `@types` que encuentre en el `node_modules/@types` de **cualquier carpeta superior** al archivo que editas. Aprovechando eso, si instalas `@types/node` **una sola vez en la carpeta que contiene todos tus proyectos**, TODOS heredan el autocompletado de los módulos de Node (`fs`, `path`, `os`…) sin instalarlo proyecto por proyecto.

```bash
cd ~/Code && npm i @types/node        # ~/Code es el default/ideal
```

- **No tiene que ser `~/Code`**: hazlo en el **ancestro común** donde vivan tus repos (ej. `~/dev`, `~/proyectos`). Lo ideal es mantener todo bajo una sola carpeta (`~/Code`) para que baste un install.
- Si trabajas en varias carpetas raíz distintas, repite el `npm i @types/node` en cada una.
- Solo aplica a **módulos de Node**. Reglas de estilo (ESLint) sí van **por proyecto** (`eslint-init`) — el enfoque "global" no funciona con el LSP.

## ⚙️ Aliases y comandos propios (en `.zshrc`)

| Comando | Qué hace |
|---|---|
| `theme 1` / `theme 2` / `theme` | **Día/noche**: cambia nvim + WezTerm + tmux juntos (1=oscuro, 2=claro, sin arg alterna). Ver [`docs/THEME.md`](docs/THEME.md) |
| `eslint-init` | Instala eslint en el proyecto actual (copia plantilla + deps) |
| `cheatsheet` | Regenera `~/Desktop/nvim_tmux_cheatsheet.pdf` desde `docs/cheatsheet.html` |
| `vim` | → `nvim` · `denos` → deno con permisos env/net |

---

## 🧠 Neovim (v0.12, base josean-dev, muy modificado)

- **Leader = Espacio.** Estructura en `nvim/lua/accel/` (core: options/keymaps; plugins/*).
- **TypeScript = `tsgo`** (TypeScript 7 nativo en Go, `@typescript/native-preview`). Toggle a `ts_ls` con `use_tsgo` en `plugins/lsp/lspconfig.lua`. `ts_ls` excluido del auto-enable de mason para no correr dos servidores.
- **treesitter en rama `main`** (la `master` está EOL para 0.12). **Requiere el CLI `tree-sitter`** (npm) para compilar parsers. Highlight se arranca por buffer con `vim.treesitter.start()` en autocmd FileType.
- **ESLint**: el LSP solo se activa si el proyecto tiene config (gate en `root_dir`). Config **por proyecto** con `eslint-init` (no global — el global no funciona con editores). `eslint_d` quitado de nvim-lint.
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

---

## ⚠️ Gotchas / lecciones aprendidas (LEER)

1. **Cambios de config requieren reiniciar esa app.** La instancia abierta usa la config vieja. `:qa`+reabrir nvim; `Ctrl+a r` o reiniciar tmux; WezTerm recarga al guardar. **El detach/attach de tmux NO reinicia nada.**
2. **NUNCA mandar `SIGUSR1` a WezTerm** → lo **cierra** (no lo recarga). Para recargarlo: `touch` a `~/.wezterm.lua` (tarda ~1s, seguro).
3. **tmux-power carga async** (vía tpm) → gana carreras al arrancar. Por eso la barra clara se aplica con un **delay** (`sleep 1`) en `.tmux.conf`.
4. **tmux renderiza el fondo de la barra con la opción vieja `status-bg`**, no solo `status-style` → hay que setear **ambas**.
5. **continuum** (auto-guardado) depende de su hook en `status-right` → re-inyectar con `set -ag status-right` tras cambiar la barra; continuum debe cargar DESPUÉS de los temas.
6. **Glyphs powerline** ` ` = bytes `\xee\x82\xb0` / `\xee\x82\xb2`. Se pierden al escribir/`tmux show` → construir con `printf`/heredoc usando los bytes (ver `tmux/theme-light.conf` y THEME.md).
7. **treesitter main** necesita el CLI `tree-sitter` para compilar parsers.
8. **ESLint global en carpeta padre NO funciona** con el LSP/eslint_d → config por proyecto.
9. **El teal de flexoki que combina con lualine es `#24837b`** (no el olivo `#66800b`).

## 📌 Pendientes / notas

- Conflicto `<leader>d`: es "cortar al portapapeles" (global) y "diagnóstico de línea" (LSP, buffer-local). En archivos con LSP gana el diagnóstico. Sin resolver.
- `{ name = "luasnip" }` está comentado en `nvim-cmp.lua` (decisión del usuario) → `Tab` ya no salta campos de snippet, solo cicla el menú.
- **Cheatsheet PDF**: `~/Desktop/nvim_tmux_cheatsheet.pdf` (regenerar con `cheatsheet`). Fuente: `docs/cheatsheet.html`.
