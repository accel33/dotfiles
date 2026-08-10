return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	-- Solo para las MARCAS de cambios en el margen (│ verde/azul/rojo).
	-- Los atajos de hunks (<leader>h*, ]h/[h) se quitaron en ago 2026: todo el
	-- flujo de git va por LazyGit (<leader>lg). Si un día los quieres de vuelta,
	-- están en el historial de git de este archivo.
	opts = {},
}
