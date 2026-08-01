-- ftplugin/java.lua — arranque de jdtls vía nvim-jdtls (corre por cada buffer .java).
--
-- Por qué aquí y no en lspconfig: jdtls es especial (necesita workspace por
-- proyecto, bundles de debug/test, comandos propios). El patrón oficial de
-- nvim-jdtls es arrancarlo por-buffer desde ftplugin. jdtls está EXCLUIDO del
-- auto-enable de mason (ver lua/accel/plugins/lsp/mason.lua) para no arrancarlo
-- dos veces.
--
-- Requisitos: JDK 21+ para EJECUTAR jdtls + paquetes mason (jdtls, java-debug-adapter,
-- java-test). Ver docs/JAVA.md.

local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then
  vim.notify("[java] nvim-jdtls no está instalado (revisa lazy)", vim.log.levels.ERROR)
  return
end

local home = os.getenv("HOME")
local mason = vim.fn.stdpath("data") .. "/mason"

local function pkg(name)
  return mason .. "/packages/" .. name
end

-- Primer path existente de una lista (o nil).
local function first_existing(paths)
  for _, p in ipairs(paths) do
    if p and p ~= "" and vim.fn.filereadable(p) == 1 or (p and vim.fn.isdirectory(p) == 1) then
      return p
    end
  end
  return nil
end

-------------------------------------------------------------------------------
-- 1) JDK para EJECUTAR jdtls (necesita 21+). Elegimos el primero que exista.
-------------------------------------------------------------------------------
local java_bin = first_existing({
  "/opt/homebrew/opt/openjdk@21/bin/java", -- LTS (preferido)
  "/opt/homebrew/opt/openjdk/bin/java", -- brew openjdk (23) sirve también
  (os.getenv("JAVA_HOME") or "") .. "/bin/java",
  vim.fn.exepath("java"),
})
if not java_bin then
  vim.notify("[java] No encuentro un JDK 21+ para arrancar jdtls", vim.log.levels.ERROR)
  return
end

-- Home de un JDK dado su symlink 'opt' de brew (keg): <opt>/libexec/openjdk.jdk/Contents/Home
local function brew_jdk_home(opt)
  local h = opt .. "/libexec/openjdk.jdk/Contents/Home"
  if vim.fn.isdirectory(h) == 1 then
    return h
  end
  return nil
end

-------------------------------------------------------------------------------
-- 2) Runtimes que jdtls ofrece a los proyectos (los que existan en el sistema).
-------------------------------------------------------------------------------
local runtimes = {}
local jdk21_home = brew_jdk_home("/opt/homebrew/opt/openjdk@21")
if jdk21_home then
  table.insert(runtimes, { name = "JavaSE-21", path = jdk21_home, default = true })
end
local jdk23_home = brew_jdk_home("/opt/homebrew/opt/openjdk")
if jdk23_home then
  table.insert(runtimes, { name = "JavaSE-23", path = jdk23_home })
end

-------------------------------------------------------------------------------
-- 3) Launcher jar + directorio de config según SO/arch.
-------------------------------------------------------------------------------
local launcher = vim.fn.glob(pkg("jdtls") .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher == "" then
  vim.notify("[java] No encuentro el launcher de jdtls (¿instalado en mason?)", vim.log.levels.ERROR)
  return
end

-- jdtls trae un directorio de config por SO/arch (config_mac_arm, config_mac,
-- config_linux, ...). Elegimos según la máquina.
local config_dir
if vim.fn.has("mac") == 1 then
  local is_arm = jit and jit.arch == "arm64"
  config_dir = pkg("jdtls") .. (is_arm and "/config_mac_arm" or "/config_mac")
else
  config_dir = pkg("jdtls") .. "/config_linux"
end

-------------------------------------------------------------------------------
-- 4) Workspace por proyecto (jdtls guarda índices/estado ahí).
-------------------------------------------------------------------------------
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".project" }
local root_dir = jdtls.setup.find_root(root_markers)
if not root_dir or root_dir == "" then
  root_dir = vim.fn.getcwd()
end
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

-------------------------------------------------------------------------------
-- 5) Bundles opcionales (debug + test). Solo si están instalados.
-------------------------------------------------------------------------------
local bundles = {}
local java_debug_jar = vim.fn.glob(pkg("java-debug-adapter") .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
if java_debug_jar ~= "" then
  table.insert(bundles, java_debug_jar)
end
local java_test_glob = vim.fn.glob(pkg("java-test") .. "/extension/server/*.jar", true)
if java_test_glob ~= "" then
  vim.list_extend(bundles, vim.split(java_test_glob, "\n"))
end

-------------------------------------------------------------------------------
-- 6) Capabilities (autocompletado nvim-cmp) + extended capabilities de jdtls.
-------------------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-------------------------------------------------------------------------------
-- 7) on_attach: keymaps de Java + codelens.
-------------------------------------------------------------------------------
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end
  -- Refactors específicos de Java (nvim-jdtls):
  map("n", "<leader>jo", jdtls.organize_imports, "Java: organizar imports")
  map("n", "<leader>jv", jdtls.extract_variable, "Java: extraer variable")
  map("x", "<leader>jv", function() jdtls.extract_variable(true) end, "Java: extraer variable (sel)")
  map("n", "<leader>jc", jdtls.extract_constant, "Java: extraer constante")
  map("x", "<leader>jc", function() jdtls.extract_constant(true) end, "Java: extraer constante (sel)")
  map("x", "<leader>jm", function() jdtls.extract_method(true) end, "Java: extraer método (sel)")
  -- Tests (requiere java-test):
  map("n", "<leader>jtc", jdtls.test_class, "Java: test clase")
  map("n", "<leader>jtm", jdtls.test_nearest_method, "Java: test método actual")
  -- Debug (requiere java-debug-adapter + nvim-dap):
  local ok_dap, dap = pcall(require, "dap")
  if ok_dap then
    map("n", "<leader>jdb", dap.toggle_breakpoint, "Java: breakpoint")
    map("n", "<leader>jdc", dap.continue, "Java: continuar/depurar")
  end

end

-------------------------------------------------------------------------------
-- 8) Config final y arranque.
-------------------------------------------------------------------------------
local config = {
  name = "jdtls",
  cmd = {
    java_bin,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      references = { includeDecompiledSources = true },
      -- codelens "N references / M implementations" arriba de clases/métodos: OFF
      -- (si algún día lo quieres, pon enabled=true y descomenta el refresh en on_attach).
      referencesCodeLens = { enabled = false },
      implementationsCodeLens = { enabled = false },
      inlayHints = { parameterNames = { enabled = "all" } },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      format = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.junit.Assert.*",
          "org.mockito.Mockito.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "java", "javax", "com", "org" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = runtimes,
      },
    },
  },
}

jdtls.start_or_attach(config)

-- Correr el archivo actual sin compilar a mano (single-file source mode, JDK 11+).
-- Ideal para practicar: escribe una clase con main y córrela con <leader>jR.
-- (Para proyectos Maven/Gradle usa los comandos de build, no esto.)
vim.keymap.set("n", "<leader>jR", function()
  if vim.bo.modified then
    vim.cmd("write")
  end
  local file = vim.fn.expand("%:p")
  vim.cmd("botright 15split | terminal java " .. vim.fn.fnameescape(file))
  vim.cmd("startinsert")
end, { buffer = true, silent = true, desc = "Java: correr archivo actual (single-file)" })

-- Etiqueta de grupo en which-key para <leader>j (solo estético).
local ok_wk, wk = pcall(require, "which-key")
if ok_wk then
  pcall(wk.add, {
    { "<leader>j", group = "Java", buffer = 0 },
    { "<leader>jt", group = "Java test", buffer = 0 },
    { "<leader>jd", group = "Java debug", buffer = 0 },
  })
end

-- DAP (depuración) si hay bundle de debug + nvim-dap.
if #bundles > 0 then
  pcall(function()
    jdtls.setup_dap({ hotcodereplace = "auto" })
  end)
end
