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
