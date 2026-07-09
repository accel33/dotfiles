return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- rama nueva (compatible con Neovim 0.11+/0.12). master está congelada.
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

    -- parsers a instalar (mismos que antes + tmux)
    local ensure_installed = {
      "json", "javascript", "typescript", "tsx", "yaml", "html", "css",
      "prisma", "markdown", "markdown_inline", "svelte", "graphql", "bash",
      "lua", "vim", "dockerfile", "gitignore", "query", "vimdoc", "c",
      "rust", "tmux",
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
