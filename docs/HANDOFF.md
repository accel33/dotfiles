# Handoff — contexto para la próxima sesión de Claude (o para mí)

> Actualizado: 20-ago-2026, al cierre de la migración de laptop.
> Este archivo es la PUERTA DE ENTRADA. No duplica nada: apunta.

---

## 📖 Qué leer según el tema

| Tema | Archivo |
|---|---|
| Qué es cada archivo y cómo se conecta todo | [`MAPA.md`](MAPA.md) |
| Estructura, instalación en máquina nueva y **gotchas** (¡leer antes de tocar temas/tmux/treesitter/PDF!) | [`../README.md`](../README.md) |
| La migración de laptop 2026 (estado, checklist, limpieza de la vieja) | [`MIGRACION.md`](MIGRACION.md) |
| Java en nvim (jdtls) | [`JAVA.md`](JAVA.md) |
| Sistema de temas día/noche | [`THEME.md`](THEME.md) |

## 🤝 Reglas de trabajo con Accel (importantes, vienen de su memoria)

1. **JAMÁS `git commit` ni `git push` sin pedido explícito.** "Ya hazlo" NO es
   permiso para commitear. Él pide "commitea"/"sube" cuando quiere.
2. **Código de aprendizaje = hands-off** (ej. `~/Code/uncc-code`): solo se toca
   si él lo pide. Config y docs sí se editan.
3. Formato que le sirve: **info completa + reglas prácticas accionables +
   verificación empírica** (correr las cosas y mostrar la salida real, no suponer).
4. **Ya NO trabaja en Kambista** (salida ago 2026). Nada laboral es contexto
   vigente: ni repos k-admin/k-web, ni k8s/gcloud como trabajo activo.
5. Habla español; explicarle los términos raros (no asumir jerga).

## 🗓️ Resumen de lo hecho en agosto 2026 (detalle: `git log`)

- **Cheatsheet PDF en dark mode** (Tokyo Night, `cheatsheet`; claro con
  `--light`). Truco de márgenes: gotcha #12 del README.
- **WezTerm**: barra superior integrada sin titlebar del sistema, puntitos de
  mac DIBUJADOS (la historia de los 4 intentos está comentada en el archivo),
  `⌘⏎` = maximizar/restaurar.
- **nvim**: sin tabs arriba (bufferline off + showtabline=0) · lualine solo
  nombre · **`<leader>l` = LazyGit** (todo git va por ahí; atajos de gitsigns
  eliminados) · `gr` directo + `g` muestra el menú de which-key · **`ga`** =
  code actions, **`gR`** = rename · separador de nvim-tree visible (fix
  NvimTreeWinSeparator) · limpieza: fuera nvim-lint, eslint_d, nvim-brian.
- **Brewfile**: apps principales declaradas (con `adopt`), poda post-Kambista
  (fuera gcloud, terraform, skaffold, gradle, yarn, tetris, tlrc, unar,
  python@3.10 y taps de terceros).
- **Bootstrap**: install.sh idempotente (symlinks + theme-mode + tpm + k9s),
  README con la secuencia completa de máquina nueva — probada EN VIVO en la
  migración.
- **Docs nuevos**: MAPA.md (mapa del repo) y MIGRACION.md (la mudanza).

## ⚠️ Si esta sesión corre en la laptop VIEJA (la de Kambista)

Queda pendiente el final de la limpieza: borrar `~/.claude`, vaciar Papelera,
y entrega con formateo de IT (ver MIGRACION.md §6 — casi todo ya se ejecutó
el 20-ago). Recordárselo proactivamente.
