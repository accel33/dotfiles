-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Tokyo Night"

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

config.enable_tab_bar = false

-- ── Edición estilo macOS en la terminal ──────────────────────────────────
-- Envía las secuencias que zsh ya entiende (modo emacs), sin config extra en zsh.
-- OJO: aplica también dentro de nvim; ahí usa las motions de vim normalmente.
local act = wezterm.action
config.keys = {
  -- Option + ←/→ : saltar por PALABRA  (esc-b / esc-f)
  { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
  { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
  -- Cmd + ←/→ : INICIO / FIN de línea  (Ctrl-A / Ctrl-E)
  { key = "LeftArrow", mods = "CMD", action = act.SendString("\x01") },
  { key = "RightArrow", mods = "CMD", action = act.SendString("\x05") },
  -- Cmd + Backspace : borrar hasta el INICIO de la línea  (Ctrl-U)
  { key = "Backspace", mods = "CMD", action = act.SendString("\x15") },
  -- Option + Backspace : borrar la PALABRA anterior  (Ctrl-W)
  { key = "Backspace", mods = "OPT", action = act.SendString("\x17") },
}

-- config.window_decorations = "RESIZE"

-- config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

-- my coolnight colorscheme:
-- config.colors = {
-- 	foreground = "#CBE0F0",
-- 	background = "#011423",
-- 	cursor_bg = "#47FF9C",
-- 	cursor_border = "#47FF9C",
-- 	cursor_fg = "#011423",
-- 	selection_bg = "#033259",
-- 	selection_fg = "#CBE0F0",
-- 	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
-- 	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
-- }
--
-- and finally, return the configuration to wezterm
return config
