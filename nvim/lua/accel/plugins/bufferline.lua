return {
  "akinsho/bufferline.nvim",
  -- Barra de tabs (modo "buffers": un tab por archivo abierto, estilo VSCode).
  -- Navegación: <leader><leader> alterna anterior · <leader>fb lista fuzzy ·
  -- :ls + muestra los modificados sin guardar.
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = {
    options = {
      -- "buffers": un tab por ARCHIVO abierto (como VSCode), con indicador de
      -- modificado. "tabs" mostraba tabpages (layouts), por eso se veía vacío.
      mode = "buffers",
      separator_style = "slant",
      diagnostics = "nvim_lsp", -- muestra errores/warnings del LSP en cada tab
      show_buffer_close_icons = true,
      show_close_icon = false,
    },
  },
}
