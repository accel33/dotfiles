return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		config = function()
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