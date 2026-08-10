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
  for _, k in ipairs({ "grr", "grn", "gra", "gri", "grt" }) do
    pcall(vim.keymap.del, "n", k)
    pcall(vim.keymap.del, "n", k, { buffer = 0 })
  end
end
purge_gr_defaults()
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("PurgeGrDefaults", { clear = true }),
  callback = purge_gr_defaults,
})

-- `gr` = referencias LSP, SIEMPRE, por lento que teclees.
--
-- ¿Por qué no basta `keymap.set("n", "gr", ...)`? Porque vim tiene un comando
-- BUILTIN `gr{char}` ("replace virtual char") que espera un carácter más. Eso hace
-- `gr` ambiguo y verificado empíricamente ningún ajuste de timeout lo resuelve:
--   · timeout ON  + rápido      -> funciona (pero con un delay de timeoutlen)
--   · timeout ON  + lento       -> vence el timeout del `g`, gana el builtin `gr`
--                                  y te REEMPLAZA una letra del archivo (el bug)
--   · timeout ON  + len enorme  -> tras la `r` espera ESE tiempo -> parece colgado
--   · timeout OFF               -> nunca dispara solo con `g`+`r`
--
-- Solución: mapeamos `g` y leemos el siguiente carácter nosotros con getcharstr(),
-- que espera INDEFINIDAMENTE y no pasa por el sistema de timeouts. Si es `r` vamos
-- a referencias; cualquier otra cosa (`gg`, `gd`, `gc`, `gb`, `gU`, …) se reenvía
-- tal cual para que se comporte como siempre. Efecto extra: al ser `g` un mapeo
-- completo, which-key ya no abre el menú de opciones al pulsar `g`.
keymap.set("n", "g", function()
  local count = vim.v.count > 0 and tostring(vim.v.count) or ""
  local ok, ch = pcall(vim.fn.getcharstr) -- espera sin límite de tiempo
  if not ok or ch == nil or ch == "" or ch == "\27" then
    return -- Esc / interrupción -> cancelar
  end
  if ch == "r" then
    if not pcall(vim.cmd, "Telescope lsp_references") then
      vim.lsp.buf.references()
    end
    return
  end
  -- Reenviar `g` + la tecla. OJO con la recursión: si reenviamos con remap y la
  -- tecla es otra `g`, este mismo mapeo se dispararía otra vez (rompía `gg`).
  -- Regla: si existe algún mapeo que EMPIECE por `g<tecla>` (gd, gb, gc, gcc…)
  -- reenviamos con remap ("m") para que funcione; si no, es un comando builtin
  -- (gg, gU, gq, g_, ge…) y lo reenviamos SIN remap ("n") para no re-entrar aquí.
  -- (No usamos mapcheck(): también da match con este mapeo `g`, y siempre elegía
  --  remap -> recursión.)
  local prefix = "g" .. ch
  local function has_map(list)
    for _, m in ipairs(list) do
      if m.lhs and #m.lhs >= #prefix and m.lhs:sub(1, #prefix) == prefix then
        return true
      end
    end
    return false
  end
  local mode = (has_map(vim.api.nvim_buf_get_keymap(0, "n")) or has_map(vim.api.nvim_get_keymap("n")))
      and "m"
    or "n"
  vim.api.nvim_feedkeys(count .. "g" .. ch, mode, false)
end, { desc = "g (gr = referencias LSP, sin timeout)" })

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
