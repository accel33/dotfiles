# Java en Neovim (jdtls) — cómo quedó montado

> Configurado en julio 2026. Java funciona en Neovim con LSP completo: autocompletado,
> diagnósticos en vivo, ir-a-definición/referencias, refactors, formateo, tests y debug.
> Verificado empíricamente (attach + diagnóstico real + completion de 61 ítems + formateo).

---

## 🎯 Idea central

Java **no** usa el LSP "normal" como el resto de lenguajes. `jdtls` (el language
server de Eclipse JDT) necesita workspace por proyecto, bundles de debug/test y
comandos propios, así que se arranca con el plugin **nvim-jdtls**, **por cada
buffer `.java`**, desde [`../nvim/ftplugin/java.lua`](../nvim/ftplugin/java.lua).

Por eso `jdtls` está **excluido del auto-enable de mason** (en
[`../nvim/lua/accel/plugins/lsp/mason.lua`](../nvim/lua/accel/plugins/lsp/mason.lua)):
si mason lo arrancara como LSP normal, chocaría con nvim-jdtls (dos servidores).

```
FileType java  ──►  ftplugin/java.lua  ──►  jdtls.start_or_attach(config)
```

---

## 🧩 Piezas

| Pieza | Qué | Dónde |
|---|---|---|
| **JDK 21 (LTS)** | Ejecuta jdtls (necesita 21+). `openjdk@21` de brew, keg-only | `/opt/homebrew/opt/openjdk@21` |
| **nvim-jdtls** | Cliente/arranque de jdtls | plugin `mfussenegger/nvim-jdtls` (ft=java) |
| **nvim-dap** | Motor de depuración | plugin `mfussenegger/nvim-dap` (ft=java) |
| **mason: jdtls** | El language server (jars) | `~/.local/share/nvim/mason/packages/jdtls` |
| **mason: java-debug-adapter** | Bundle DAP para depurar | idem |
| **mason: java-test** | Correr/depurar tests JUnit | idem |
| **mason: google-java-format** | Formateo (vía conform) | idem |
| **treesitter: java** | Resaltado de sintaxis | parser `java` instalado |

### El JDK: por qué 21 y cómo lo resuelve el ftplugin

- jdtls **moderno requiere JDK 21+** para *arrancar* (el bloqueador viejo era que
  solo había Zulu **13** instalada). Ahora hay `openjdk@21` (y `openjdk` 23) de brew.
- El ftplugin **no hardcodea** la ruta: prueba en orden
  `openjdk@21` → `openjdk` (23) → `$JAVA_HOME` → `java` del PATH, y usa el primero.
- Los **runtimes** que jdtls ofrece a los proyectos (JavaSE-21, JavaSE-23) se arman
  solo con los JDK que existan en el sistema.
- `openjdk@21` es **keg-only** (brew no lo mete al PATH). Para la terminal se añadió
  en [`../zsh/.zshrc`](../zsh/.zshrc): `JAVA_HOME` + `PATH` a la 21, para que
  `java`/`javac`/`:make`/`:!java %` usen la 21 y no la vieja 13. **Neovim/jdtls NO
  depende de eso** (usa su ruta absoluta).

---

## ⌨️ Atajos (buffer `.java`, leader = Espacio)

| Atajo | Qué |
|---|---|
| `gd` `gr` `gD` `gi` `K` | Definición / referencias / declaración / implementación / hover (los LSP normales, ya los tenías) |
| `<leader>jo` | Organizar imports |
| `<leader>jv` | Extraer variable (normal y visual) |
| `<leader>jc` | Extraer constante (normal y visual) |
| `<leader>jm` | Extraer método (visual) |
| `<leader>jtc` / `<leader>jtm` | Test: clase / método actual (requiere java-test) |
| `<leader>jdb` / `<leader>jdc` | Debug: breakpoint / continuar (requiere nvim-dap) |
| `<leader>jR` | **Correr el archivo actual** (single-file, JDK 11+) en un split terminal |
| `<leader>mp` | Formatear (google-java-format) — también corre al guardar |

### Correr código para practicar

- **Un archivo suelto con `main`**: `<leader>jR` (usa `java Archivo.java`, no
  necesitas compilar a mano). O en terminal: `java Archivo.java`.
- **Compilar a `.class`**: `javac Archivo.java` y luego `java Clase`.

---

## 🎨 Formateo

- **google-java-format** vía conform (`../nvim/lua/accel/plugins/formatting.lua`).
- Configurado con `--aosp` (**4 espacios**) y `--skip-removing-unused-imports` /
  `--skip-sorting-imports` → **no te borra imports a medio escribir** mientras aprendes.
- Corre **al guardar** y con `<leader>mp`.
- ¿Prefieres estilo Google de 2 espacios? Quita `--aosp` en `formatting.lua`.
- ¿No quieres formateo automático en Java? Saca `java = { "google-java-format" }` de
  `formatters_by_ft` (seguirás pudiendo formatear a mano con `<leader>mp`, que caería
  al formateador del LSP).

---

## ✅ Cómo verificar que sigue bien

```bash
# 1) JDK correcto en terminal:
java -version    # -> openjdk 21.0.x
# 2) Abre un proyecto Java (una carpeta con .git o pom.xml/build.gradle) y un .java:
#    - Espera unos segundos (jdtls indexa el JDK la primera vez).
#    - :LspInfo / :checkhealth vim.lsp  -> debe listar el cliente "jdtls".
#    - Escribe un error de tipos (int x = "hola";) -> aparece diagnóstico.
#    - Escribe  algo.  -> autocompletado con métodos.
```

Prueba headless (sin abrir UI), sobre un proyecto con `.git`:
```bash
nvim --headless -c "lua vim.defer_fn(function()
  local b=vim.api.nvim_get_current_buf()
  vim.wait(60000,function() return #vim.lsp.get_clients({bufnr=b,name='jdtls'})>0 end,500)
  print('jdtls attached:', #vim.lsp.get_clients({bufnr=b,name='jdtls'})>0)
  vim.cmd('qa!') end, 1500)" src/TuClase.java
```

---

## ⚠️ Gotchas / notas

1. **jdtls necesita JDK 21+ para arrancar** (aunque compiles proyectos de Java 8/11/17).
   Con solo la Zulu 13 no arrancaba: ese era el pendiente viejo. Resuelto con `openjdk@21`.
2. **Primer arranque lento**: jdtls indexa el JDK/proyecto (~10-40 s). No es que esté
   colgado; míralo en la barra ("Starting Java Language Server").
3. **Workspace por proyecto** en `~/.cache/jdtls/workspace/<nombre-proyecto>`. Si un
   proyecto se comporta raro (índice corrupto), borra su carpeta ahí y reabre.
4. **root del proyecto**: se detecta por `.git`, `pom.xml`, `build.gradle`, `mvnw`,
   `gradlew`, `.project`. Sin ninguno, usa el cwd (modo archivo suelto: funciona, pero
   sin classpath de librerías).
5. **jdtls excluido de mason auto-enable** a propósito. Si algún día ves DOS clientes
   Java, revisa que siga en `exclude` de `mason.lua`.
6. **Máquina nueva**: `brew install openjdk@21`; los paquetes mason (jdtls,
   java-debug-adapter, java-test, google-java-format) se instalan solos por
   `mason-tool-installer`/`mason-lspconfig`; el parser `java` de treesitter con `:TSUpdate`.
7. **Lombok**: no está configurado (no lo necesitas para aprender). Si algún proyecto
   de trabajo usa Lombok, instala `lombok-nightly` en mason y añade
   `-javaagent:<ruta lombok.jar>` al `cmd` del ftplugin.

## 📚 Referencias usadas

- Config de **brianrbrenner/nvim** (patrón ftplugin + nvim-jdtls) — la base de esta.
- Config de **Gako358/neovim** (nix) — ideas de settings/runtimes/formateo AOSP.
- `mfussenegger/nvim-jdtls` README (patrón oficial de arranque por-buffer).
