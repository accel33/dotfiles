return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  -- optional for floating window border decoration
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    -- UNA sola tecla y sin <leader>lg como alias: si existieran ambos, ␣l
    -- tendría que esperar el timeout para saber si viene la g -> lento.
    { "<leader>l", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
