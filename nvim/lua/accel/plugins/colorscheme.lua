return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		config = function()
			-- Ajustes de fondo sobre Tokyo Night:
			--  · sidebar (nvim-tree), flotantes y popups → IGUAL que el editor
			--    (sin franjas oscuras). (El bufferline ya no existe: ver bufferline.lua.)
			--  · statusline (barra de abajo, lualine) → un tono MÁS CLARO que el
			--    editor para que se lea como una barra, sin llegar a ser tan marcada
			--    como la de tmux.
			--  · WinSeparator (línea vertical entre splits, p.ej. nvim-tree ↔ código)
			--    con color visible: como el fondo del sidebar/flotantes ahora coincide
			--    con el del editor, sin esto no se distinguía la división.
			require("tokyonight").setup({
				on_colors = function(c)
					c.bg_dark = c.bg
					c.bg_sidebar = c.bg
					c.bg_float = c.bg
					c.bg_popup = c.bg
					c.bg_statusline = "#292e42" -- gris-azul medio (sube más si quieres marcada)
				end,
				on_highlights = function(hl, c)
					-- línea de separación entre paneles claramente visible
					hl.WinSeparator = { fg = "#3b4261", bg = c.bg }
					-- OJO: no basta con WinSeparator. nvim-tree pinta el borde de SU
					-- ventana con un grupo propio (pone winhl "WinSeparator:NvimTreeWin-
					-- Separator"), y tokyonight lo colorea con el color del sidebar.
					-- Como arriba hicimos bg_sidebar = bg, ese grupo quedaba fg=bg =
					-- invisible: la línea salía entre dos splits de código, pero NO
					-- contra el árbol. Verificado con nvim_get_hl antes/después de abrirlo.
					hl.NvimTreeWinSeparator = { fg = "#3b4261", bg = c.bg }
				end,
			})

			-- lee el modo guardado por el comando `theme` (~/.config/theme-mode)
			local mode = "dark"
			local f = io.open(vim.fn.expand("~/.config/theme-mode"), "r")
			if f then
				mode = vim.trim(f:read("*a") or "dark")
				f:close()
			end
			if mode == "light" then
				vim.o.background = "light"
				vim.cmd.colorscheme("flexoki-light")
			else
				vim.o.background = "dark"
				-- Cambia el sufijo si un día quieres otra variante:
				--   tokyonight-night  (default; casi negro)
				--   tokyonight-storm  (azul-gris más claro)
				--   tokyonight-moon   (violeta suave)
				vim.cmd.colorscheme("tokyonight-night")
			end
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
	},
	-- temas claros cálidos tipo "papel":
	{ "kepano/flexoki-neovim", name = "flexoki", priority = 1000 },
	{ "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
}