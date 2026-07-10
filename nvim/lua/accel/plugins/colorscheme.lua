return {
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
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
	-- temas claros tipo "papel/crema" para probar (no activos aún):
	{ "savq/melange-nvim", name = "melange", priority = 1000 },
	{ "kepano/flexoki-neovim", name = "flexoki", priority = 1000 },
	{ "maxmx03/solarized.nvim", name = "solarized", priority = 1000 },
}