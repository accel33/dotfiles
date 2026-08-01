return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        java = { "google-java-format" },
      },
      formatters = {
        -- Java: estilo AOSP (4 espacios) y NO tocar imports, para no borrar
        -- imports a medio escribir mientras aprendes. Si prefieres el estilo
        -- Google de 2 espacios, quita "--aosp".
        ["google-java-format"] = {
          prepend_args = { "--aosp", "--skip-sorting-imports", "--skip-removing-unused-imports" },
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
