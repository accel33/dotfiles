return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- ESLint lo maneja el LSP (vscode-eslint), que solo se activa si el proyecto
    -- tiene su config. NO usamos eslint_d aquí porque: (1) sería redundante con el
    -- LSP, (2) el eslint_d de mason es viejo y no entiende flat config, y (3) daba
    -- el error "No ESLint configuration found" en proyectos sin config.
    -- Deja este mapa listo para OTROS linters (ej. stylelint, markdownlint) si algún día.
    lint.linters_by_ft = {}

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
