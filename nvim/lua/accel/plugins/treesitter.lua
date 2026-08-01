return {
  "nvim-treesitter/nvim-treesitter",
  -- rama nueva (compatible con Neovim 0.11+/0.12). master está congelada.
  -- REQUISITO: el CLI de tree-sitter (npm i -g tree-sitter-cli) para compilar parsers.
  branch = "main",
  lazy = false, -- se carga al inicio para registrar el autocmd de highlight
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- En la rama main la API cambió:
    --   * los parsers se instalan con install()
    --   * el highlight NO se activa en setup; se arranca por buffer con
    --     vim.treesitter.start() en un autocmd FileType
    require("nvim-treesitter").setup()

    -- tmux: nvim-treesitter (rama main) DROPEÓ este parser (commit 78bebef1
    -- "drop support"). Lo re-registramos con la MISMA grammar/revisión que usaba,
    -- para que install() lo reconozca (adiós al warning "skipping unsupported
    -- language: tmux") y sea recompilable en una máquina nueva.
    --
    -- ¿Por qué en un autocmd y no una asignación directa? install() llama internamente
    -- a reload_parsers(), que RECARGA el módulo `nvim-treesitter.parsers` (borra
    -- cualquier mutación directa) y justo después dispara el evento `User TSUpdate`.
    -- Enganchándonos a ese evento, re-registramos tmux DESPUÉS de cada recarga, a
    -- tiempo para que install() lo vea. generate=true => genera parser.c desde
    -- grammar.json al compilar (requiere el CLI tree-sitter, ya requerido aquí).
    -- Las queries van versionadas en nvim/queries/tmux/ (parser externo => nvim-ts
    -- ya no las provee). Verificado: build + resaltado OK (241 capturas en .tmux.conf).
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").tmux = {
          install_info = {
            url = "https://github.com/Freed-Wu/tree-sitter-tmux",
            revision = "5c4bc6815372ca6c9a0f5a1188d73c0475523cce",
            generate = true,
          },
          tier = 3,
        }
      end,
    })

    -- parsers a instalar (mismos que antes + tmux + java)
    local ensure_installed = {
      "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
      "prisma", "markdown", "markdown_inline", "svelte", "graphql", "bash",
      "lua", "vim", "dockerfile", "gitignore", "query", "vimdoc", "c",
      "rust", "tmux", "java",
    }
    require("nvim-treesitter").install(ensure_installed)

    -- autotag (cerrar/renombrar tags en JSX/HTML) — en main se configura aparte
    require("nvim-ts-autotag").setup()

    -- arrancar highlight + indent al abrir cada archivo (si hay parser instalado)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local ok = pcall(vim.treesitter.start)
        if ok then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
