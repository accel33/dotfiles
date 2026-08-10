return {
  "akinsho/bufferline.nvim",
  -- DESACTIVADO (ago 2026): los tabs de arriba se acumulaban y confundían.
  -- Ahora no hay nada arriba (`showtabline = 0` en core/options.lua) y el archivo
  -- actual se ve abajo en lualine. Los buffers SIGUEN abiertos: se navegan con
  -- <leader><leader> (alternar), <leader>fb (lista fuzzy) y :ls + (modificados).
  -- Para recuperar la barra: pon `enabled = true` y quita el showtabline de options.lua.
  enabled = false,
  -- Barra de tabs (modo "buffers": un tab por archivo abierto, estilo VSCode).
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  opts = function()
    -- Unificar el fondo de la barra con el del editor: bufferline por defecto
    -- se auto-oscurece un pelo más que Normal (~#0e0e14). Lo forzamos a usar
    -- el bg de Normal para que arriba se vea del mismo color que el código.
    local function normal_bg()
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = "Normal" })
      return (ok and hl.bg) and string.format("#%06x", hl.bg) or nil
    end
    local bg = normal_bg()
    local hi = bg
        and {
          fill = { bg = bg },
          background = { bg = bg },
          buffer_visible = { bg = bg },
          buffer_selected = { bg = bg, bold = true },
          separator = { fg = bg, bg = bg },
          separator_visible = { fg = bg, bg = bg },
          separator_selected = { fg = bg, bg = bg },
          tab = { bg = bg },
          tab_selected = { bg = bg },
          tab_close = { bg = bg },
          close_button = { bg = bg },
          close_button_visible = { bg = bg },
          close_button_selected = { bg = bg },
          modified = { bg = bg },
          modified_visible = { bg = bg },
          modified_selected = { bg = bg },
          indicator_selected = { bg = bg },
          duplicate = { bg = bg },
          duplicate_visible = { bg = bg },
          duplicate_selected = { bg = bg },
        }
      or nil
    return {
      options = {
        mode = "buffers", -- un tab por ARCHIVO abierto (estilo VSCode)
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = false,
      },
      highlights = hi,
    }
  end,
}
