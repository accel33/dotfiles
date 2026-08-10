return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    -- timeout normal: 500ms para secuencias como jk/kj en insert y los <leader>*.
    -- `gr` (referencias) NO depende de esto: se maneja aparte en core/keymaps.lua
    -- leyendo la tecla con getcharstr(), así que no le afecta el timeout.
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {},
}

