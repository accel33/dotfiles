# dotfiles

Mi configuración personal para macOS. Gestionada con symlinks.

## Contenido

| Carpeta | Qué config es | Destino del symlink |
|---|---|---|
| `nvim/` | Neovim (lua/accel, plugins con lazy.nvim) | `~/.config/nvim` |
| `zsh/` | Zsh: `.zshrc`, `.zshenv`, `.zprofile`, `.profile`, `.p10k.zsh` | `~` |
| `tmux/` | `.tmux.conf` (plugins vía tpm, no versionados) | `~/.tmux.conf` |
| `wezterm/` | `.wezterm.lua` | `~/.wezterm.lua` |
| `git/` | `.gitconfig` + `ignore` global | `~/.gitconfig`, `~/.config/git/ignore` |

## Instalación en una máquina nueva

```bash
git clone git@github.com:accel33/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Dependencias (Homebrew)

Todo mi software está en el `Brewfile`. Para reinstalarlo de un jalón en una Mac nueva:

```bash
brew bundle install --file=~/dotfiles/Brewfile
```

Para actualizar el `Brewfile` con lo que tenga instalado hoy:

```bash
brew bundle dump --file=~/dotfiles/Brewfile --force
```

Además:
- **oh-my-zsh**: https://ohmyz.sh
- **tpm** (tmux plugin manager): `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- **nvm**: https://github.com/nvm-sh/nvm

## Notas

- Los plugins de Neovim (lazy) y tmux (tpm) se reinstalan solos; no se versionan.
- `lazy-lock.json` sí se versiona para fijar versiones de plugins de Neovim.
- Nunca meter aquí secretos: `.ssh`, `.aws`, `.config/gcloud`, `.kube`, `.docker`, historiales.
