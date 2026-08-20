# Migración de laptop — checklist

> Plan para pasar a una máquina nueva SIN los repos de Kambista.
> La instalación base la cubre el [README](../README.md#-instalación-en-una-máquina-nueva)
> (Homebrew → nvm → oh-my-zsh → clone → `brew bundle` → `install.sh`).
> Este archivo cubre lo que el Brewfile NO puede: **los datos de cada app**.
>
> Regla de oro: no borres/formatees la vieja hasta tachar TODO en la nueva.

---

## 1️⃣ En la laptop VIEJA (exports y copias)

- [ ] **Push de dotfiles**: `cd ~/dotfiles && git status` limpio y `git push`.
      Sin esto no hay nada que clonar en la nueva.
- [ ] **Raycast**: Settings → Advanced → **Export** → guarda el `.rayconfig`
      (pide contraseña; puede llevar tokens de extensiones → NO va al repo).
- [ ] **Maccy**: `defaults export org.p0deje.Maccy ~/Desktop/maccy.plist`
- [ ] **Claude Code**: copiar `~/.claude/` y `~/.claude.json`
      (memoria de cómo trabajo contigo, settings, historial de sesiones).
- [ ] **SSH — copiar SOLO lo personal** (inventario verificado ago 2026):
      `~/.ssh/id_ed25519` + `id_ed25519.pub` (tu llave personal, la de
      accelwtf@gmail.com — autentica GitHub como accel33, GitLab y grama-server)
      y `~/.ssh/config`. **NO copiar**: `id_rsa`* (llave de accel@kambista.com)
      ni `google_compute_engine`* (SSH del GCP del trabajo).
- [ ] **Historial de shell** (opcional): copiar `~/.zhistory`.
- [ ] **Sesiones de tmux** (opcional): copiar `~/.tmux/resurrect/` si quieres
      revivirlas tal cual.
- [ ] **Firefox — decidir nivel de continuidad** (ver §3). Si eliges el clon
      total: copiar la carpeta `~/Library/Application Support/Firefox/`.
      OJO: el perfil NO va al repo de dotfiles (pesa, y lleva cookies y
      sesiones = secretos) — viaja como carpeta suelta igual que lo demás.
- [ ] **De Kambista NO viaja NADA** (salida de la empresa, ago 2026): ni repos,
      ni `~/.kube/config`, ni credenciales de gcloud, ni la llave `id_rsa`.
      El acceso muere solo cuando desactiven tu cuenta, pero tampoco lo cargues.
- [ ] Todo lo copiado va en un pendrive / AirDrop / carpeta temporal de iCloud.
      Bórralo de ahí al terminar (hay llaves y tokens).

## 2️⃣ En la laptop NUEVA (instalación)

- [ ] Seguir la secuencia del [README](../README.md#-instalación-en-una-máquina-nueva)
      tal cual y EN ORDEN. Con eso quedan: todo el software del Brewfile
      (apps incluidas), symlinks, tema, tpm, skin de k9s.
- [ ] Restaurar lo del paso 1: `~/.ssh/` (solo lo personal), `~/.claude/` +
      `~/.claude.json`, `~/.zhistory`, `~/.tmux/resurrect/`.
- [ ] `gh auth login` (git usa gh para credenciales — sin esto no hay push).

## 3️⃣ Datos por app (en la nueva, al primer arranque)

| App | Qué hacer |
|---|---|
| **Firefox** 🦊 | El único con decisión real. **Opción A — Firefox Sync** (recomendada): login con la cuenta Mozilla → marcadores, contraseñas, extensiones e historial llegan solos; las sesiones abiertas y cookies NO (re-loguearse en cada sitio). **Opción B — clon total**: antes de abrir Firefox por primera vez, pega el perfil copiado en `~/Library/Application Support/Firefox/` → TODO idéntico, incluidas sesiones. B es más fiel; A es más limpia (aprovecha para purgar). |
| **VSCode** | Settings Sync se encarga (login GitHub) — extensiones además ya vienen del Brewfile. |
| **Obsidian** | Nada: el vault vive en iCloud (`iCloud~md~obsidian/Documents/2026`) → aparece al loguear iCloud, con su config `.obsidian/` dentro. |
| **WezTerm / nvim / tmux / zsh / k9s** | Nada: 100% dotfiles. |
| **Claude** | App: login. CLI: restaurada la carpeta `~/.claude` del paso 1, sigue sabiendo todo. |
| **Raycast** | Settings → Advanced → **Import** del `.rayconfig`. |
| **Maccy** | `defaults import org.p0deje.Maccy maccy.plist` (antes de abrirlo). |
| **Passwords (Apple)** 🆕 | Empezar de cero (el KeePassXC era de la empresa). Se usa el de Apple: gratis, sincroniza por iCloud, y tiene **extensión oficial para Firefox** (instalarla al primer arranque). Plan B si molesta o sales del ecosistema: Bitwarden. |
| **Docker** | Nada que migrar: imágenes/contenedores se reconstruyen (`docker pull`/`build`). |
| **MongoDB Compass** | Las conexiones guardadas quedan en la vieja; anótalas o re-créalas (suelen ser 2-3 URIs). |
| **Steam** | Login; juegos se re-descargan; saves por Steam Cloud. |
| **Zoom / WhatsApp / ChatGPT** | Login (WhatsApp: QR desde el teléfono). |
| **Slack / Discord / iTerm / Lens / Aptakube / Mingo / Surfshark** | Fuera del Brewfile a propósito (decisión ago 2026): instalar a mano solo si se extrañan. |

## ✅ Verificación final en la nueva

```bash
cd ~/dotfiles && git log --oneline -3   # el repo llegó
nvim --headless "+checkhealth vim.lsp" +qa
tmux new -s test
java -version
cheatsheet                              # PDF con Chrome headless
```

Y lo de siempre: los [gotchas del README](../README.md#%EF%B8%8F-gotchas--lecciones-aprendidas-leer)
si algo se comporta raro.
