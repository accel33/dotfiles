return {
  "numToStr/Comment.nvim",
  keys = {
    { "gcc", mode = "n", desc = "Comment toggle current line" },
    { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
    { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
    { "gbc", mode = "n", desc = "Comment toggle current block" },
    { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
    { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      desc = "Toggle comment",
    },
    {
      "<leader>/",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      mode = "v",
      desc = "Toggle comment",
    },
  },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    local ts_pre_hook = ts_context_commentstring.create_pre_hook()

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files
      -- con fallback al commentstring nativo: sin esto, Comment.nvim (archivado)
      -- revienta en nvim 0.12 con archivos sin parser de treesitter (ej: tmux.conf)
      pre_hook = function(ctx)
        local ok, result = pcall(ts_pre_hook, ctx)
        if ok and result then
          return result
        end
        local cs = vim.bo.commentstring
        if cs and cs ~= "" then
          return cs
        end
      end,
    })
  end,
}
