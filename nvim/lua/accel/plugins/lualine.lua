return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- pending updates count

    -- muestra qué LSP está activo en el buffer (ej. "tsgo", "lua_ls")
    local function lsp_names()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end
      local names = {}
      for _, c in ipairs(clients) do
        names[#names + 1] = c.name
      end
      return " " .. table.concat(names, ", ")
    end

    lualine.setup({
      options = {
        -- "auto" hace que la barra siga el colorscheme (tokyonight oscuro / flexoki claro)
        theme = "auto",
        globalstatus = true, -- una sola barra abajo aunque haya splits
      },
      sections = {
        -- lualine_a = modo · lualine_b = rama git + diff · lualine_c = archivo + diagnósticos
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { lsp_names, icon = "" }, -- LSP activo
          { "encoding" },
          { "filetype" },
        },
        -- lualine_y = progreso (%) · lualine_z = línea:columna
      },
    })
  end,
}
