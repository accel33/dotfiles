return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "rust_analyzer",
        "ts_ls",
        "lua_ls",
        "cmake",
        "eslint",
        "jdtls", -- Java (Eclipse JDT). OJO: jdtls necesita un JDK 21+ para arrancar.
      },
      -- v2 auto-arranca con vim.lsp.enable() todo paquete instalado que tenga
      -- config LSP. stylua es un FORMATTER (lo maneja conform), pero nvim-lspconfig
      -- ahora trae lsp/stylua.lua con `cmd = { stylua, --lsp }` y el binario real
      -- no soporta --lsp -> exit code 2. Lo excluimos del auto-enable.
      automatic_enable = {
        -- ts_ls lo habilitamos manualmente en lspconfig.lua (elegimos tsgo o ts_ls,
        -- nunca los dos a la vez).
        -- jdtls NO se arranca como LSP normal: lo maneja nvim-jdtls por-buffer
        -- (ver ftplugin/java.lua). Si mason lo auto-arranca, choca con nvim-jdtls.
        exclude = { "stylua", "stylua3p_ls", "ts_ls", "jdtls" },
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        -- Java (usados por ftplugin/java.lua de forma condicional):
        "java-debug-adapter", -- DAP para depurar Java (nvim-dap)
        "java-test", -- correr/depurar tests JUnit desde nvim-jdtls
        "google-java-format", -- formateo de Java (conform)
      },
    })
  end,
}
