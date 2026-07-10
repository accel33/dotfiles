# Sistema de temas día/noche — cómo funciona (paso a paso)

El comando **`theme`** cambia Neovim + WezTerm + tmux al mismo tiempo entre **oscuro** (Tokyo Night) y **claro** (Flexoki). Este documento explica cada pieza para poder mantenerlo/repararlo.

```
theme 1   # o: theme dark   → OSCURO
theme 2   # o: theme light  → CLARO
theme     # sin argumento   → alterna
```

## 🎯 Idea central: un archivo de estado compartido

Todo gira alrededor de **`~/.config/theme-mode`**, un archivo con una palabra: `dark` o `light`.
- El comando **escribe** ese archivo.
- Neovim, WezTerm y tmux lo **leen al arrancar** (persistencia) y el comando además los actualiza **en vivo**.

El script es **`docs/theme.sh`** (alias `theme`). Hace 4 cosas:

```
1. Escribe dark|light en ~/.config/theme-mode
2. nvim  → a los nvim ABIERTOS vía sockets:  nvim --server <sock> --remote-expr "execute('set background=.. | colorscheme ..')"
3. tmux  → light: source theme-light.conf   |   dark: re-aplica tmux-power + fuerza status-style oscuro
4. WezTerm → touch ~/.wezterm.lua  (dispara recarga; ~1s)   ⚠️ NUNCA SIGUSR1 (cierra WezTerm)
```

- **Oscuro** = nvim `tokyonight-night` · WezTerm Tokyo Night · tmux **tmux-power**
- **Claro**  = nvim `flexoki-light` · WezTerm esquema flexoki · tmux **barra flexoki teal propia**

---

## 1. Neovim

- **En vivo**: `theme.sh` encuentra los sockets (`$TMPDIR/nvim.*/*/nvim.*.0`) y manda `--remote-expr` con `colorscheme` + `background`. No interrumpe lo que escribes.
- **Al arrancar**: `nvim/lua/accel/plugins/colorscheme.lua` (dentro del config de tokyonight) **lee `~/.config/theme-mode`** y aplica `flexoki-light`+`background=light` o `tokyonight-night`+`background=dark`.
- **lualine** usa `theme="auto"` → se re-tematiza sola al cambiar el colorscheme (por eso la barra de nvim sigue al tema sin más código).
- ⚠️ Cambiar `colorscheme.lua`/`lualine.lua` requiere **reiniciar nvim** para que el nvim abierto lo tome.

## 2. WezTerm

- `wezterm/.wezterm.lua` define un `color_scheme` custom `flexoki-light` y **lee `~/.config/theme-mode`**: si `light` usa flexoki, si no Tokyo Night (oscuro).
- Para aplicar el cambio, `theme.sh` hace **`touch ~/dotfiles/wezterm/.wezterm.lua`** → WezTerm detecta el cambio de config y recarga (~1s).
- ⚠️ **NO usar `pkill -USR1 wezterm-gui`**: WezTerm no trata SIGUSR1 como recarga → la señal por defecto lo **mata**. (Este fue el bug del "se cae la terminal".) El `touch` es más lento pero seguro.

## 3. tmux (lo más intrincado)

**Noche = tmux-power** (plugin, teal `colour6`). **Día = barra propia** en `tmux/theme-light.conf` (flexoki teal), porque no existe una barra flexoki oficial para tmux.

### En vivo (`theme.sh`)
- **light**: `tmux source-file ~/dotfiles/tmux/theme-light.conf`
- **dark**: `tmux run-shell tmux-power.tmux` + `sleep 0.4` + `set -g status-style "bg=#262626,fg=#a8a8a8"` (tmux-power NO resetea `status-style`) + re-inyecta hook de continuum.

### Al arrancar (`.tmux.conf`, al final, después de `run tpm`)
```tmux
if-shell '[ "$(cat ~/.config/theme-mode 2>/dev/null)" = light ]' \
  'run-shell -b "sleep 1; tmux source-file ~/dotfiles/tmux/theme-light.conf"'
```
El **`sleep 1`** es clave: tmux-power carga **async** vía tpm; sin el delay, tmux-power se aplica DESPUÉS y deja la barra oscura. El delay hace que la barra clara gane.

### Las 3 trampas de la barra de tmux (todas resueltas en `theme-light.conf`)
1. **Fondo del medio sale oscuro** → tmux renderiza el fondo con la opción VIEJA `status-bg`, no solo `status-style`. Fix: setear **ambas** (`status-bg` Y `status-style`).
2. **Se rompe el auto-guardado (continuum)** → cualquier barra que setee `status-right` borra el hook de continuum. Fix: incluir `#(~/.tmux/plugins/tmux-continuum/scripts/continuum_save.sh)` dentro del `status-right`, o re-inyectarlo con `set -ag status-right`.
3. **Las flechas ` ` no aparecen** → son los bytes `\xee\x82\xb0` (derecha) y `\xee\x82\xb2` (izquierda). Al escribir el archivo o al hacer `tmux show` se convierten en `_` por locale. Fix: **construir `theme-light.conf` con `printf`/heredoc** metiendo los bytes crudos:
   ```bash
   RA=$'\xee\x82\xb0'; LA=$'\xee\x82\xb2'
   cat > ~/dotfiles/tmux/theme-light.conf <<EOF
   ... ${RA} ... ${LA} ...
   EOF
   ```
   Verificar que quedaron: `hexdump -C theme-light.conf | grep 'ee 82'`.

### Colores flexoki usados en la barra clara
| Rol | Hex |
|---|---|
| Acento (teal, = el de lualine) | `#24837b` |
| Fondo base (gris papel) | `#e6e4d9` |
| Segmento gris 2 | `#dad8ce` |
| Texto tenue | `#6f6e69` |
| Texto oscuro | `#100f0f` |
| Texto claro (sobre teal) | `#fffcf0` |

El layout imita a tmux-power: izquierda `usuario@host` (teal) → `sesión` (gris); ventanas con flechas; derecha `hora` (gris) → `fecha` (teal); todo con flechas ` `.

---

## 🔧 Cómo cambiar / afinar

- **Otro verde/acento del día**: editar `#24837b` en `tmux/theme-light.conf` (y en nvim el colorscheme flexoki ya define lo suyo).
- **Otro tema claro en nvim**: cambiar `flexoki-light` en `colorscheme.lua` (hay kanagawa-lotus, catppuccin-latte, rose-pine-dawn instalados).
- **Regenerar la barra clara** (si se dañan las flechas): re-correr el bloque `printf`/heredoc de arriba.
- **Probar sin romper tu sesión**: usar un socket aparte → `tmux -L prueba new -d`, testear, `tmux -L prueba kill-server`.

## ✅ Cómo verificar que todo quedó bien
```bash
theme 2   # día:  nvim claro + wezterm claro + barra tmux teal con flechas
theme 1   # noche: nvim tokyonight + wezterm oscuro + tmux-power
# tras reiniciar tmux estando en día, la barra clara debe aguantar (por el delay)
tmux show -g status-right | grep continuum_save.sh   # el auto-guardado sigue vivo
```
