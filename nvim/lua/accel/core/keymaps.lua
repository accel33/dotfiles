vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-------------------------
--  GENERAL KEYMAPS
-------------------------

-- clear search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Neovim 0.11+ define por defecto grr/grn/gra/gri/grt (references/rename/action/…).
-- Como todos son prefijo `gr`, which-key espera el 3er carácter y `gr` queda ambiguo
-- (si tecleas despacio sale un menú). Los borramos aquí al arrancar Y en cada buffer
-- nuevo (algunos ftplugins los redefinen). Así `gr` es SIEMPRE ir-a-referencias.
local function purge_gr_defaults()
  -- grx = codelens, default nuevo de nvim 0.12 (si sale otro gr* en futuras
  -- versiones, agrégalo aquí: cualquier mapeo más largo vuelve ambiguo a gr)
  for _, k in ipairs({ "grr", "grn", "gra", "gri", "grt", "grx" }) do
    pcall(vim.keymap.del, "n", k)
    pcall(vim.keymap.del, "n", k, { buffer = 0 })
  end
end
purge_gr_defaults()
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("PurgeGrDefaults", { clear = true }),
  callback = purge_gr_defaults,
})

-- `gr` = referencias LSP, como mapeo DIRECTO.
--
-- Historia (ago 2026): antes había aquí un mega-mapeo de `g` entera con
-- getcharstr() porque `gr` era ambiguo — pero la ambigüedad la causaban los
-- defaults grr/grn/gra/gri/grt de nvim 0.11 (gr era PREFIJO de mapeos más
-- largos). Como purge_gr_defaults() ya los borra (arriba), `gr` queda como
-- mapeo completo y único: nuestro mapeo TAPA al builtin gr{char} (replace
-- virtual char) sin importar lo lento que teclees, y `g` vuelve a ser un
-- prefijo normal → which-key MUESTRA el menú de opciones al pulsar g.
-- (El mega-mapeo mataba ese menú: está en el historial de git si hay dudas.)
keymap.set("n", "gr", function()
  if not pcall(vim.cmd, "Telescope lsp_references") then
    vim.lsp.buf.references()
  end
end, { desc = "Referencias LSP" })

-- salir a modo normal con kj (insert)
keymap.set("i", "kj", "<Esc>", { desc = "Salir a modo normal (kj)" })
keymap.set("i", "jk", "<Esc>", { desc = "Salir a modo normal (kj)" })

-- go back
keymap.set("n", "gb", "<C-o>", { desc = "Go back in jump list" })

-------------------------
--  PORTAPAPELES: solo 'y' copia al sistema
-------------------------
-- borrar / cambiar / x van al "black hole" (no pisan el portapapeles)
keymap.set({ "n", "x" }, "d", '"_d', { desc = "Borrar sin tocar el portapapeles" })
keymap.set({ "n", "x" }, "D", '"_D', { desc = "Borrar (a fin de línea) sin portapapeles" })
keymap.set({ "n", "x" }, "c", '"_c', { desc = "Cambiar sin tocar el portapapeles" })
keymap.set({ "n", "x" }, "C", '"_C', { desc = "Cambiar (a fin de línea) sin portapapeles" })
keymap.set({ "n", "x" }, "x", '"_x', { desc = "Borrar carácter sin portapapeles" })

-- cortar DE VERDAD (sí va al portapapeles) con <leader>d
keymap.set({ "n", "x" }, "<leader>d", '"+d', { desc = "Cortar al portapapeles" })

-- en visual, pegar encima NO pisa lo que tienes yankeado
keymap.set("x", "p", '"_dP', { desc = "Pegar sin perder el yank" })

-------------------------
--  SPLITS  (ventanas DENTRO de nvim; las "pestañas"/ventanas del terminal las maneja tmux)
-------------------------

-- increment/decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Modo resize INCREMENTAL estilo tmux: <leader>sr y luego tap h/j/k/l (repetible).
--   h/l = ancho (ideal para nvim-tree) · j/k = alto · cualquier otra tecla sale.
keymap.set("n", "<leader>sr", function()
  local step = 3
  while true do
    vim.api.nvim_echo({ { "-- RESIZE --  h/l ancho · j/k alto · otra tecla sale", "ModeMsg" } }, false, {})
    local ok, ch = pcall(vim.fn.getcharstr)
    if not ok then break end
    if ch == "h" then
      vim.cmd("vertical resize -" .. step)
    elseif ch == "l" then
      vim.cmd("vertical resize +" .. step)
    elseif ch == "j" then
      vim.cmd("resize -" .. step)
    elseif ch == "k" then
      vim.cmd("resize +" .. step)
    else
      break
    end
    vim.cmd("redraw")
  end
  vim.api.nvim_echo({ { "", "" } }, false, {})
end, { desc = "Modo resize (hjkl, estilo tmux)" })

-- (Pestañas de nvim eliminadas: ahora las "pestañas" son ventanas de tmux
--  [prefix + c/n/p]. Los tabpages nativos siguen existiendo si algún día los
--  necesitas con :tabnew / :tabn / :tabclose, pero sin atajos de <leader>.)

-------------------------
--  BUFFERS
-------------------------
-- alternar entre el buffer actual y el anterior (reemplazo cómodo de Ctrl-^)
keymap.set("n", "<leader><leader>", "<C-^>", { desc = "Alternar buffer anterior" })

-- ver los buffers con cambios SIN GUARDAR (:ls + filtra a los modificados)
keymap.set("n", "<leader>bm", "<cmd>ls +<CR>", { desc = "Buffers modificados (sin guardar)" })

-- Terminal: se usa un pane de tmux (Ctrl+j al de abajo), no la terminal interna de nvim.
