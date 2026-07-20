# Cheatsheet de lazygit + git (lo útil nomás)

Referencia rápida de las teclas y conceptos que más se usan. Dentro de lazygit, **`?`** siempre te muestra las acciones del panel donde estás parado (y **`g?`** en nvim-tree).

---

## 🧠 La idea base de git (3 zonas)

```
working tree   →   staging (index)   →   repo (commits)
(tus archivos)     (lo que vas a          (historial
                    commitear)             guardado)
     │  espacio/git add  │   c / git commit   │
```

Casi todo en git es mover cosas entre esas 3 zonas.

---

## ⌨️ Navegación (paneles)

| Tecla | Acción |
|---|---|
| `1`–`5` | Ir a panel: 1 Status · 2 Files · 3 Branches · 4 Commits · 5 Stash |
| `Tab` / `Esc` | Ciclar entre paneles / retroceder |
| `?` | **Ver TODAS las acciones del panel actual** ← úsala siempre |
| `x` | Menú de acciones del contexto |
| `R` | Refrescar (relee el disco) |
| `q` | Salir |

---

## 📁 Panel Files (2) — preparar y commitear

| Tecla | Acción |
|---|---|
| `espacio` | Stagear / des-stagear el archivo (= `git add`) |
| `a` | Stagear TODO |
| `c` | **Commitear** lo que está staged |
| `d` | Descartar cambios del archivo ⚠️ (se pierden) |
| `e` | Editar el archivo |
| `Enter` | Ver/stagear líneas sueltas (staging parcial) |

---

## 📜 Panel Commits (4) — lo que confunde a todos

**Cada tecla hace algo MUY distinto. Esta tabla es la que importa:**

| Tecla | Acción | Cuándo usarla |
|---|---|---|
| `espacio` | **Checkout** al commit (solo mirar, "detached HEAD") | Solo para *ver* cómo estaba antes. **NO trae cambios.** |
| `g` | **Reset** tu rama a ese commit | Volver atrás en el tiempo (borra los de después) |
| `t` | **Revert**: crea un commit nuevo que deshace ese | Deshacer algo ya commiteado, dejando registro |
| `c` → `v` | **Cherry-pick**: copiar un commit → pegarlo aquí | ✅ Traer los cambios de OTRO commit al actual |
| `d` | Drop: borrar el commit (rebase) | Eliminar un commit del historial |
| `r` | Reword: cambiar el mensaje | Corregir un mensaje |
| `s` / `f` | Squash / Fixup: fusionar con el de abajo | Juntar commits |
| `A` | Amend: meter lo staged al último commit | "Se me olvidó algo en el último commit" |

### 🔑 Reset: 3 sabores (al presionar `g`)
- **soft**: mueve la rama, deja tus cambios staged.
- **mixed** (default): mueve la rama, deja cambios sin stagear.
- **hard**: mueve la rama y **borra** los cambios del working tree ⚠️.

### 🔑 "Traer de vuelta" cambios revertidos
- Opción A: **cherry-pick** el commit original (`c` sobre él → `v`).
- Opción B: **revert del revert** (`t` sobre el commit de revert).

---

## 🌿 Panel Branches (3)

| Tecla | Acción |
|---|---|
| `espacio` | Checkout (cambiar de rama) |
| `n` | Nueva rama |
| `d` | Borrar rama |
| `M` | Merge de la rama seleccionada a la actual |

## 📦 Panel Stash (5) — guardar cambios sin commitear

| Tecla | Acción |
|---|---|
| `s` (en Files) | Guardar cambios actuales al stash |
| `espacio` | Aplicar el stash |
| `d` | Borrar el stash |

---

## 🛟 Red de seguridad (¡quita el miedo!)

| Comando / tecla | Qué hace |
|---|---|
| `z` / `Z` | **Undo / Redo** dentro de lazygit ← salvavidas |
| `git reflog` | La "caja negra": TODO lo que hiciste, aunque parezca borrado |
| — | Mientras no pasen ~90 días, **nada se pierde de verdad** |

Si te enredas: `git reflog` → encuentra el punto bueno → `git reset --hard <hash>`.

---

## 💡 Lecciones aprendidas (mías)

1. **`.gitignore` NO afecta archivos ya trackeados.** Para dejar de trackear algo ya commiteado: `git rm --cached <archivo>` y luego lo ignora.
2. **Git no borra carpetas, solo archivos.** Una carpeta "vacía" que sigue apareciendo suele tener un `.DS_Store` oculto dentro.
3. **`checkout` ≠ traer cambios.** Para traer cambios de otro commit: **cherry-pick** (`c`→`v`).
4. **revert** crea un commit nuevo (no borra historia); **reset** mueve la rama.

---

## 📚 Aprender más
- Dentro de lazygit: **`?`** en cada panel.
- Interactivo/visual: **learngitbranching.js.org** (ideal para revert/reset/cherry-pick).
