return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- pending updates count

    lualine.setup({
      options = {
        -- "auto" hace que la barra siga el colorscheme activo (tokyonight oscuro /
        -- flexoki claro) y se re-tematice sola cuando cambias con el comando `theme`.
        theme = "auto",
      },
      -- misma info de siempre: modo · rama+diff · archivo+diagnósticos ·
      -- (x) updates de lazy, encoding, fileformat, filetype · progreso · línea:col
      sections = {
        -- filename con path=0: SOLO el nombre ("promesas.js"), sin la ruta.
        -- path: 0=nombre · 1=relativa · 2=absoluta · 3=absoluta(~) · 4=nombre+carpeta
        -- (si algún día confundes dos archivos con el mismo nombre, sube a path=1)
        lualine_c = {
          { "filename", path = 0, symbols = { modified = " ●", readonly = " ", newfile = " " } },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}
