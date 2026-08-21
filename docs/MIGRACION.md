# Migración de laptop — checklist

> ## 📌 ESTADO (20-ago-2026): COMPLETADA ✅
> Se ejecutó desde la laptop VIEJA (Kambista) el 19–20 de agosto.
> - **Nueva**: verificada — software completo, dotfiles, `git push` de prueba
>   OK, `cheatsheet` OK, Firefox/Raycast/Obsidian restaurados.
> - **Vieja**: limpieza §6 casi completa — `rm` de credenciales/historiales/
>   perfiles ejecutados y VERIFICADOS (gh deslogueado, Llavero limpio,
>   clipboard de Maccy borrado, Apple ID cerrado). Falta: `rm -rf ~/.claude
>   ~/.claude.json` al final, Papelera, y entrega con formateo de IT.
> - **Sesiones de Claude en la nueva**: el primer restore usó el zip del
>   19-ago 20:44 (NO incluye la saga de la migración). Hay un
>   `claude-fresh.zip` + `claude-fresh.json` (Desktop de la vieja) para
>   pasar por AirDrop: en la nueva → ⌘Q a Claude → `rm -rf ~/.claude &&
>   mkdir -p ~/.claude && ditto -x -k claude-fresh.zip ~/.claude && cp
>   claude-fresh.json ~/.claude.json` → reabrir.
> - Pendiente menor: borrar `migracion-accel` de iCloud y de la Mac nueva.

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

- [ ] **PRIMERO restaurar `~/.ssh/`** (lo personal del paso 1): el clone del
      repo va por `git@github.com:` y sin la llave no autentica.
      `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_ed25519` después de copiar.
- [ ] Seguir la secuencia del [README](../README.md#-instalación-en-una-máquina-nueva)
      tal cual y EN ORDEN. Con eso quedan: todo el software del Brewfile
      (apps incluidas), symlinks, tema, tpm, skin de k9s.
- [ ] Restaurar el resto del paso 1: `~/.claude/` + `~/.claude.json`,
      `~/.zhistory`, `~/.tmux/resurrect/`.
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

## 6️⃣ Limpieza de la laptop VIEJA (de Kambista — el día de la entrega)

> SOLO cuando la nueva esté verificada (Firefox con tu perfil + un `git push`
> de prueba funcionando). Orden exacto:

- [ ] En la NUEVA: `gh auth login` (si no se hizo ya).
- [ ] En la vieja — deslogueos: Firefox Sync → cerrar sesión ·
      **WhatsApp: desvincular DESDE EL TELÉFONO** (Dispositivos vinculados →
      esta Mac) · `gh auth logout` (mata el token y limpia el Llavero) ·
      **Apple ID**: Ajustes del Sistema → tu nombre → Cerrar sesión
      (crítico: con tu iCloud activo la Mac queda con Activation Lock y IT
      no puede reinstalarla; si pregunta "conservar una copia", NO).
- [ ] La llave SSH se borra SOLO de la laptop (archivos): en GitHub NO se
      toca nada — es la misma llave que usa la Mac nueva.
- [ ] **Historial del clipboard (Maccy)**: cerrar Maccy (icono de barra →
      Quit) y luego
      `rm -rf ~/Library/Containers/org.p0deje.Maccy && defaults delete org.p0deje.Maccy`
      (en el container vive el historial — verificado; el defaults son los ajustes).
- [ ] Borrado (cerrar Firefox/Chrome/Slack/Discord antes):
      `rm -rf ~/.ssh ~/.aws ~/.kube ~/.config/gcloud ~/.config/gh ~/.docker/config.json ~/.zhistory ~/.zsh_history ~/Documents/abcp ~/Downloads/migracion-accel`
      y
      `rm -rf ~/Library/Application\ Support/Google/Chrome ~/Library/Application\ Support/Firefox ~/Library/Application\ Support/discord ~/Library/Application\ Support/Slack`
- [ ] Al final de todo (Claude ya respaldado en migracion-accel):
      `rm -rf ~/.claude ~/.claude.json`
- [ ] Vaciar la Papelera · borrar `migracion-accel` de iCloud (y de la nueva
      cuando todo esté restaurado).
- [ ] Entregar pidiendo que **IT la formatee contigo presente**.

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
