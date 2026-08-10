-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Esquema claro Flexoki (papel cálido) definido localmente
config.color_schemes = {
	["flexoki-light"] = {
		background = "#FFFCF0",
		foreground = "#100F0F",
		cursor_bg = "#100F0F",
		cursor_border = "#100F0F",
		cursor_fg = "#FFFCF0",
		selection_bg = "#DAD8CE",
		selection_fg = "#100F0F",
		ansi = { "#100F0F", "#AF3029", "#66800B", "#AD8301", "#205EA6", "#A02F6F", "#24837B", "#CECDC3" },
		brights = { "#B7B5AC", "#D14D41", "#879A39", "#D0A215", "#4385BE", "#CE5D97", "#3AA99F", "#FFFCF0" },
	},
}

-- El comando `theme` escribe ~/.config/theme-mode (dark|light); WezTerm lo lee aquí.
-- Al cambiarlo, el script hace `touch` de este archivo para que WezTerm recargue solo.
local function theme_mode()
	local f = io.open(os.getenv("HOME") .. "/.config/theme-mode", "r")
	if f then
		local m = (f:read("*l") or "dark")
		f:close()
		return m
	end
	return "dark"
end

-- `bg` = fondo del esquema activo. Lo reusamos abajo para pintar la barra de
-- arriba del MISMO color que el terminal, y que se vea como una sola pieza.
local bg
if theme_mode() == "light" then
	config.color_scheme = "flexoki-light"
	bg = config.color_schemes["flexoki-light"].background -- #FFFCF0
else
	config.color_scheme = "Tokyo Night"
	bg = wezterm.color.get_builtin_schemes()["Tokyo Night"].background -- #1a1b26
end

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 19

-- ── Barra superior integrada (sin barra de título de macOS) ──────────────
-- Objetivo: barra ALTA estilo app (Claude/Chrome) del color del terminal, con
-- los puntitos de mac con aire alrededor.
--
-- Historia completa (ago 2026) — 4 intentos, no repetir el viaje:
--   1. Botones NATIVOS (INTEGRATED_BUTTONS + MacOsNative): AppKit los clava en
--      posición fija, WezTerm no puede moverlos (verificado en su código fuente).
--      La barra solo crece por debajo → puntos siempre pegados arriba.
--   2. Botones dibujados en barra fancy (estilo Gnome/Windows): se centran bien,
--      pero integrated_title_button_color solo admite UN color → sin semáforo.
--   3. Barra retro + tab_bar_style: semáforo perfecto y clickeable... pero la
--      barra retro mide exactamente 1 fila de texto → sin padding vertical.
--   4. ← ACTUAL: barra fancy ALTA sin botones del sistema; los puntitos los
--      dibujamos en el STATUS izquierdo (colores reales de mac, centrados
--      verticalmente por la propia barra, padding a gusto).
--
-- ÚNICO trade-off del intento 4: los puntos son DECORATIVOS (el status no es
-- clickeable). Cerrar = ⌘w · minimizar = ⌘m · salir = ⌘q; arrastrar la barra
-- SÍ mueve la ventana. Si un día prefieres puntos clickeables aceptando barra
-- fina, recupera el intento 3 del historial de git de este archivo.
-- "RESIZE" a secas: sin titlebar del sistema y sin botones nativos.
-- NO intentar recuperar el doble-click-para-maximizar con INTEGRATED_BUTTONS +
-- integrated_title_buttons = {} — probado (ago 2026): la lista vacía NO oculta
-- los botones nativos y quedan 6 puntos (los del sistema + los nuestros).
-- El maximizar vive en un atajo: ⌘⏎ (ver config.keys abajo).
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false

config.window_frame = {
	active_titlebar_bg = bg,
	inactive_titlebar_bg = bg,
	-- ALTURA de la barra — y también el TAMAÑO y SEPARACIÓN de los puntos (son
	-- texto: escalan todos con este número). Calibrado vs. apps reales (Claude,
	-- Obsidian): 19 ≈ clavado · 18 = puntos un pelín chicos · 22 = todo grande.
	font_size = 19,
	-- este font también dibuja los ● del status (Meslo los trae seguro)
	font = wezterm.font("MesloLGS Nerd Font Mono"),
}

-- Los puntitos (status izquierdo). Colores: el semáforo REAL de las apps
-- modernas de macOS es más apagado que los hex "clásicos" (#ff5f57/#febc2e/
-- #28c840 se ven chillones al lado de Claude/Obsidian); estos están igualados
-- a screenshots de esas apps.
-- Padding izquierdo = espacios del primer Text · gap entre puntos = espacio tras ●.
wezterm.on("update-status", function(window, _)
	window:set_left_status(wezterm.format({
		{ Background = { Color = bg } },
		{ Foreground = { Color = "#ec6a5e" } },
		{ Text = " ● " },
		{ Foreground = { Color = "#f4bf4f" } },
		{ Text = "● " },
		{ Foreground = { Color = "#61c554" } },
		{ Text = "●" },
	}))
end)

-- ── Edición estilo macOS en la terminal ──────────────────────────────────
-- Envía las secuencias que zsh ya entiende (modo emacs), sin config extra en zsh.
-- OJO: aplica también dentro de nvim; ahí usa las motions de vim normalmente.
local act = wezterm.action

-- ⌘⏎ = maximizar / restaurar la ventana (reemplaza el doble-click del titlebar,
-- que se perdió al quitar la barra de título del sistema). El estado vive en
-- esta variable: si maximizas de otra forma (arrastrando), puede desfasarse un
-- toggle — inofensivo, el siguiente ⌘⏎ lo endereza.
local maximized = false
local function toggle_maximize(window, _)
	if maximized then
		window:restore()
	else
		window:maximize()
	end
	maximized = not maximized
end

config.keys = {
	{ key = "Enter", mods = "CMD", action = wezterm.action_callback(toggle_maximize) },
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

-- config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.window_close_confirmation = "NeverPrompt"

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
