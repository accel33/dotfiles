return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Hands Down Neu navigation INSIDE NvimTree
      -- default mappings
      api.config.mappings.default_on_attach(bufnr)
      -- REMOVE DEFAULT nvim-tree BINDINGS FOR 'e', 'm' AND 'a'
      -- vim.keymap.set("n", "e", "<Nop>", opts("Disable default e"))
      -- vim.keymap.set("n", "e", api.node.navigate.sibling.prev, opts("Up"))
      -- vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))

      -- vim.keymap.set("n", "m", api.fs.create, opts("Create File Or Directory"))
      -- vim.keymap.set("n", "a", "<Nop>", opts("Disable default a"))

      -- vim.keymap.set("n", ",", "h", opts("Move left"))
      -- vim.keymap.set("n", "a", "j", opts("Move down"))
      -- vim.keymap.set("n", "e", "k", opts("Move up"))
      -- vim.keymap.set("n", "i", "l", opts("Move right"))
      -- vim.keymap.set("n", "f", "w", opts("Move word"))
      -- vim.keymap.set("n", "F", "W", opts("Move WORD"))
    end

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true },
        -- resalta el nombre del archivo abierto en el árbol (como VSCode)
        highlight_opened_files = "name",
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      sync_root_with_cwd = true,
      -- sigue y RESALTA el archivo actual en el árbol (como VSCode).
      update_focused_file = { enable = true },
      actions = {
        open_file = { window_picker = { enable = false } },
      },
      filters = { custom = { ".DS_Store" } },
      git = { ignore = false },
      trash = { cmd = "trash" },

      on_attach = my_on_attach,
    })

    ---------------------------------------------------
    -- OUTSIDE KEYMAPS
    ---------------------------------------------------
    local keymap = vim.keymap

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Find file in tree" })
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse all" })
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh" })
    keymap.set("n", "<leader>ea", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })

    keymap.set("n", "<leader>ed", function()
      local node = require("nvim-tree.lib").get_node_at_cursor()
      if node then
        local filename = node.name
        local filepath = node.absolute_path
        local new_filepath = filepath:match("(.*)/(.*)"):sub(1, -2) .. "/" .. "copy_" .. filename
        vim.fn.system({ "cp", filepath, new_filepath })
        vim.cmd("NvimTreeRefresh")
        print("File duplicated: " .. new_filepath)
      end
    end, { desc = "Duplicate file" })
  end,
}
