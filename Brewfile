# Resource monitor (htop moderno con gráficas)
brew "btop"
# Secure runtime for JavaScript and TypeScript
brew "deno"
# Modern, maintained replacement for ls
brew "eza"
# Buscador de archivos rápido — REQUERIDO por telescope (find_command en telescope.lua)
brew "fd"
# GitHub command-line tool
brew "gh"
# Interactive process viewer
brew "htop"
# Lightweight and flexible command-line JSON processor
brew "jq"
# Kubernetes CLI To Manage Your Clusters In Style!
brew "k9s"
# Kubernetes command-line interface
brew "kubernetes-cli"
# Simple terminal UI for git commands
brew "lazygit"
# Incremental parsing library
brew "tree-sitter"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# JDK 21 LTS (keg-only) — REQUERIDO para jdtls (Java en nvim); ver docs/JAVA.md
brew "openjdk@21"
# Theme for zsh
brew "powerlevel10k"
# Interpreted, interactive, object-oriented programming language
brew "python@3.10"
# Search tool like grep and The Silver Searcher
brew "ripgrep"
# Terminal multiplexer
brew "tmux"
# CLI tool that moves files or folder to the trash
brew "trash"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Shell extension to navigate your filesystem faster
brew "zoxide"
# Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh
brew "zsh-syntax-highlighting"
# ── Apps principales (adopt: si ya está instalada a mano, brew la adopta) ──
# Passwords: se usa el de Apple (gratis, extensión oficial para Firefox).
# Si algún día molesta o sales del ecosistema Apple: cask "bitwarden".
# ChatGPT app de escritorio (Atlas descartado a propósito, ago 2026)
cask "chatgpt-classic", args: { adopt: true }
# Claude Desktop (Claude Code CLI va aparte, en la sección npm)
cask "claude", args: { adopt: true }
# Docker Desktop (el cask viejo "docker" quedó deprecado)
cask "docker-desktop", args: { adopt: true }
# Navegador principal (datos: Firefox Sync o copiar el perfil)
cask "firefox", args: { adopt: true }
# GUI de MongoDB
cask "mongodb-compass", args: { adopt: true }
# Notas (el vault vive en iCloud -> migra solo)
cask "obsidian", args: { adopt: true }
cask "steam", args: { adopt: true }
# Solo instala el editor; los settings van por Settings Sync (las extensiones
# sí están declaradas abajo en la sección vscode)
cask "visual-studio-code", args: { adopt: true }
cask "whatsapp", args: { adopt: true }

cask "font-meslo-lg-nerd-font"
# REQUERIDO por docs/build-pdf.sh (el cheatsheet se imprime con Chrome headless).
# adopt: si Chrome ya existe (instalado a mano), brew lo adopta en vez de fallar.
cask "google-chrome", args: { adopt: true }
# Set of tools to manage resources and applications hosted on Google Cloud
cask "gcloud-cli"
# Display key code, unicode value and modifier keys state for any key combination
cask "key-codes"
# Clipboard manager
cask "maccy"
# Launcher (la config NO viaja por dotfiles: exportar .rayconfig desde
# Settings → Advanced → Export e importarlo en la máquina nueva)
cask "raycast", args: { adopt: true }
# Collaboration platform for API development
cask "postman"
# GPU-accelerated cross-platform terminal emulator and multiplexer
cask "wezterm"
# Video communication and virtual meeting platform
cask "zoom"
vscode "anthropic.claude-code"
vscode "dbaeumer.vscode-eslint"
vscode "dracula-theme.theme-dracula"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "manishsencha.readme-preview"
vscode "mikestead.dotenv"
vscode "pkief.material-icon-theme"
vscode "redhat.java"
vscode "redhat.vscode-yaml"
vscode "vscodevim.vim"
vscode "vue.volar"
vscode "wesbos.theme-cobalt2"
vscode "yoavbls.pretty-ts-errors"
npm "@anthropic-ai/claude-code"
npm "@typescript/native-preview"
npm "corepack"
# prettier: conform (nvim) lo busca en el PATH; además debe estar en
# ~/.nvm/default-packages para que cada versión nueva de node lo traiga (gotcha #10)
npm "prettier"
npm "tree-sitter-cli"
