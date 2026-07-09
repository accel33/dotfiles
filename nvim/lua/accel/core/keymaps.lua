vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-------------------------
--  GENERAL KEYMAPS
-------------------------

-- clear search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

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
--  SPLITS & TABS
-------------------------

-- increment/decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open buffer in new tab" })

-- Terminal: se usa un pane de tmux (Ctrl+j al de abajo), no la terminal interna de nvim.

-------------------------
--  HANDS DOWN NEU LAYOUT
-------------------------
-- Equivalent to VSCodeVim Hands Down Neu remap
--  , → h
--  a → j
--  e → k
--  i → l
--  f → w
--  F → W
--  q → i
--  m → a

-- ===== NORMAL MODE ===== "n"
-- ===== VISUAL MODE ===== "v"
-- ===== OPERATOR-PENDING MODE ===== "o"

-- keymap.set("n", ",", "h")
-- keymap.set("n", "a", "j")
-- keymap.set("n", "e", "k")
-- keymap.set("n", "i", "l")
-- keymap.set("n", "f", "w")
-- keymap.set("n", "F", "W")
-- keymap.set("n", "q", "i")
-- keymap.set("n", "m", "a")

-- keymap.set("v", ",", "h")
-- keymap.set("v", "a", "j")
-- keymap.set("v", "e", "k")
-- keymap.set("v", "i", "l")
-- keymap.set("v", "f", "w")
-- keymap.set("v", "F", "W")
-- keymap.set("v", "q", "i")
-- keymap.set("v", "m", "a")

-- keymap.set("o", ",", "h")
-- keymap.set("o", "a", "j")
-- keymap.set("o", "e", "k")
-- keymap.set("o", "i", "l")
-- keymap.set("o", "f", "w")
-- keymap.set("o", "F", "W")
-- keymap.set("o", "q", "i")
-- keymap.set("o", "m", "a")

-- keymap.set("i", "aa", "<Esc>")
-- keymap.set("i", "tt", "<Esc>")
-- keymap.set("i", "sn", "<Esc>")

-------------------------
--  COLEMAK MOD-DHM MOTION REMAPS
-------------------------
-- Equivalent to VSCodeVim:
--  m → h
--  n → j
--  e → k
--  i → l
--  l → e
--  h → i

-- ===== NORMAL MODE ===== "n"
-- ===== VISUAL MODE ===== "v"
-- ===== OPERATOR-PENDING MODE ===== "o"

-- keymap.set("n", "m", "h")
-- keymap.set("n", "n", "j")
-- keymap.set("n", "e", "k")
-- keymap.set("n", "i", "l")
-- keymap.set("n", "l", "e")
-- keymap.set("n", "h", "i")

-- keymap.set("v", "m", "h")
-- keymap.set("v", "n", "j")
-- keymap.set("v", "e", "k")
-- keymap.set("v", "i", "l")
-- keymap.set("v", "l", "e")
-- keymap.set("v", "h", "i")

-- keymap.set("o", "m", "h")
-- keymap.set("o", "n", "j")
-- keymap.set("o", "l", "e")
-- keymap.set("o", "h", "i")
