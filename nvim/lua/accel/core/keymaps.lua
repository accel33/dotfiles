vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-------------------------
--  GENERAL KEYMAPS
-------------------------

-- clear search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- salir a modo normal con kj (insert)
keymap.set("i", "kj", "<Esc>", { desc = "Salir a modo normal (kj)" })

-- go back
keymap.set("n", "gb", "<C-o>", { desc = "Go back in jump list" })

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

-- terminal (toggle nativo: reutiliza el mismo buffer, oculta sin matar el proceso)
local term_state = { buf = nil, win = nil }
local function toggle_term()
  -- si la ventana de la terminal está visible, la ocultamos (el proceso sigue vivo)
  if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    vim.api.nvim_win_hide(term_state.win)
    term_state.win = nil
    return
  end

  -- abrir un split horizontal abajo, de 15 líneas
  vim.cmd("botright split")
  vim.cmd("resize 15")
  term_state.win = vim.api.nvim_get_current_win()

  -- reutilizar el buffer de terminal si sigue vivo; si no, crear uno nuevo
  if term_state.buf and vim.api.nvim_buf_is_valid(term_state.buf) then
    vim.api.nvim_win_set_buf(term_state.win, term_state.buf)
  else
    vim.cmd("terminal")
    term_state.buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end

keymap.set("n", "<leader>tt", toggle_term, { desc = "Terminal (toggle)" })

-- en modo terminal: salir a modo normal con Esc Esc (luego <leader>tt para ocultar)
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal -> modo normal" })

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
