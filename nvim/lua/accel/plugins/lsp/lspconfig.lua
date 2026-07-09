return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        -- Inlay hints: anotaciones inline de tipos y nombres de parámetro
        opts.desc = "Toggle inlay hints"
        keymap.set("n", "<leader>ih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
        end, opts)

        -- mostrarlos por defecto (comenta estas 3 líneas si te resultan ruidosos)
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- API nueva (Neovim 0.11+ / mason-lspconfig v2): se configura con
    -- vim.lsp.config() y mason-lspconfig hace el vim.lsp.enable() (automatic_enable).
    -- Ya NO existe mason_lspconfig.setup_handlers ni lspconfig[server].setup().

    -- capabilities (autocompletado) para todos los servers
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- lua_ls: reconocer el global "vim" y ajustes de diagnostics/completion
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            disable = { "trailing-space" },
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    -- ts_ls: filtrar el diagnostic 80001 (sugerencia de convertir a módulo ES)
    vim.lsp.config("ts_ls", {
      handlers = {
        ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          if result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(diagnostic)
              return diagnostic.code ~= 80001
            end, result.diagnostics)
          end
          vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
        end,
      },
    })

    -- TypeScript: servidor nativo en Go (tsgo = "TypeScript 7", preview, mucho más rápido
    -- y con soporte de monorepos). Si el binario 'tsgo' está instalado lo usamos; si no,
    -- caemos al clásico ts_ls. NUNCA los dos a la vez (diagnósticos/completado duplicados).
    --   Instalar tsgo:  npm install -g @typescript/native-preview
    --   Volver a ts_ls: pon  use_tsgo = false  (abajo) y reinicia Neovim.
    local use_tsgo = vim.fn.executable("tsgo") == 1
    if use_tsgo then
      vim.lsp.enable("tsgo")
    else
      vim.lsp.enable("ts_ls")
    end
  end,
}
