-- Java = nvim-jdtls (mfussenegger). jdtls NO se arranca como LSP normal por
-- lspconfig/mason (está excluido en mason.lua); el arranque real vive en
-- ftplugin/java.lua y corre por cada buffer .java (patrón oficial de nvim-jdtls).
--
-- REQUISITOS (fuera de nvim):
--   * Un JDK 21+ para EJECUTAR jdtls (aquí usamos openjdk@21 de brew; 23 también sirve).
--   * paquetes mason: jdtls, java-debug-adapter, java-test (ver mason.lua).
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java", -- lazy lo carga al abrir un .java, antes de ftplugin/java.lua
  },
  -- DAP: motor de depuración que usa java-debug-adapter (jdtls.setup_dap()).
  {
    "mfussenegger/nvim-dap",
    ft = "java",
  },
}
