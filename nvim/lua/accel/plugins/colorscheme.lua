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
	-- temas claros cálidos tipo "papel":
	{ "kepano/flexoki-neovim", name = "flexoki", priority = 1000 },
	{ "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
}