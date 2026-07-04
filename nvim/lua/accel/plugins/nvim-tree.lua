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

    -- pass to setup along with your other options
    require("nvim-tree").setup({
      ---
      on_attach = my_on_attach,
      ---
    })

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      renderer = {
        indent_markers = { enable = true },
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

-- BEGIN_ON_ATTACH_DEFAULT
-- vim.keymap.set("n",          "<C-]>",          api.tree.change_root_to_node,       opts("CD"))
-- vim.keymap.set("n",          "<C-e>",          api.node.open.replace_tree_buffer,  opts("Open: In Place"))
-- vim.keymap.set("n",          "<C-k>",          api.node.show_info_popup,           opts("Info"))
-- vim.keymap.set("n",          "<C-r>",          api.fs.rename_sub,                  opts("Rename: Omit Filename"))
-- vim.keymap.set("n",          "<C-t>",          api.node.open.tab,                  opts("Open: New Tab"))
-- vim.keymap.set("n",          "<C-v>",          api.node.open.vertical,             opts("Open: Vertical Split"))
-- vim.keymap.set("n",          "<C-x>",          api.node.open.horizontal,           opts("Open: Horizontal Split"))
-- vim.keymap.set("n",          "<BS>",           api.node.navigate.parent_close,     opts("Close Directory"))
-- vim.keymap.set("n",          "<CR>",           api.node.open.edit,                 opts("Open"))
-- vim.keymap.set({ "n", "x" }, "<Del>",          api.fs.remove,                      opts("Delete"))
-- vim.keymap.set("n",          "<Tab>",          api.node.open.preview,              opts("Open Preview"))
-- vim.keymap.set("n",          ">",              api.node.navigate.sibling.next,     opts("Next Sibling"))
-- vim.keymap.set("n",          "<",              api.node.navigate.sibling.prev,     opts("Previous Sibling"))
-- vim.keymap.set("n",          ".",              api.node.run.cmd,                   opts("Run Command"))
-- vim.keymap.set("n",          "-",              api.tree.change_root_to_parent,     opts("Up"))
-- vim.keymap.set("n",          "a",              api.fs.create,                      opts("Create File Or Directory"))
-- vim.keymap.set("n",          "bd",             api.marks.bulk.delete,              opts("Delete Bookmarked"))
-- vim.keymap.set("n",          "bt",             api.marks.bulk.trash,               opts("Trash Bookmarked"))
-- vim.keymap.set("n",          "bmv",            api.marks.bulk.move,                opts("Move Bookmarked"))
-- vim.keymap.set("n",          "B",              api.filter.no_buffer.toggle,        opts("Toggle Filter: No Buffer"))
-- vim.keymap.set({ "n", "x" }, "c",              api.fs.copy.node,                   opts("Copy"))
-- vim.keymap.set("n",          "C",              api.filter.git.clean.toggle,        opts("Toggle Filter: Git Clean"))
-- vim.keymap.set("n",          "[c",             api.node.navigate.git.prev,         opts("Prev Git"))
-- vim.keymap.set("n",          "]c",             api.node.navigate.git.next,         opts("Next Git"))
-- vim.keymap.set({ "n", "x" }, "d",              api.fs.remove,                      opts("Delete"))
-- vim.keymap.set({ "n", "x" }, "D",              api.fs.trash,                       opts("Trash"))
-- vim.keymap.set("n",          "E",              api.tree.expand_all,                opts("Expand All"))
-- vim.keymap.set("n",          "e",              api.fs.rename_basename,             opts("Rename: Basename"))
-- vim.keymap.set("n",          "]e",             api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
-- vim.keymap.set("n",          "[e",             api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
-- vim.keymap.set("n",          "F",              api.filter.live.clear,              opts("Live Filter: Clear"))
-- vim.keymap.set("n",          "f",              api.filter.live.start,              opts("Live Filter: Start"))
-- vim.keymap.set("n",          "g?",             api.tree.toggle_help,               opts("Help"))
-- vim.keymap.set("n",          "gy",             api.fs.copy.absolute_path,          opts("Copy Absolute Path"))
-- vim.keymap.set("n",          "ge",             api.fs.copy.basename,               opts("Copy Basename"))
-- vim.keymap.set("n",          "H",              api.filter.dotfiles.toggle,         opts("Toggle Filter: Dotfiles"))
-- vim.keymap.set("n",          "I",              api.filter.git.ignored.toggle,      opts("Toggle Filter: Git Ignored"))
-- vim.keymap.set("n",          "J",              api.node.navigate.sibling.last,     opts("Last Sibling"))
-- vim.keymap.set("n",          "K",              api.node.navigate.sibling.first,    opts("First Sibling"))
-- vim.keymap.set("n",          "L",              api.node.open.toggle_group_empty,   opts("Toggle Group Empty"))
-- vim.keymap.set("n",          "M",              api.filter.no_bookmark.toggle,      opts("Toggle Filter: No Bookmark"))
-- vim.keymap.set({ "n", "x" }, "m",              api.marks.toggle,                   opts("Toggle Bookmark"))
-- vim.keymap.set("n",          "o",              api.node.open.edit,                 opts("Open"))
-- vim.keymap.set("n",          "O",              api.node.open.no_window_picker,     opts("Open: No Window Picker"))
-- vim.keymap.set("n",          "p",              api.fs.paste,                       opts("Paste"))
-- vim.keymap.set("n",          "P",              api.node.navigate.parent,           opts("Parent Directory"))
-- vim.keymap.set("n",          "q",              api.tree.close,                     opts("Close"))
-- vim.keymap.set("n",          "r",              api.fs.rename,                      opts("Rename"))
-- vim.keymap.set("n",          "R",              api.tree.reload,                    opts("Refresh"))
-- vim.keymap.set("n",          "s",              api.node.run.system,                opts("Run System"))
-- vim.keymap.set("n",          "S",              api.tree.search_node,               opts("Search"))
-- vim.keymap.set("n",          "u",              api.fs.rename_full,                 opts("Rename: Full Path"))
-- vim.keymap.set("n",          "U",              api.filter.custom.toggle,           opts("Toggle Filter: Custom"))
-- vim.keymap.set("n",          "W",              api.tree.collapse_all,              opts("Collapse All"))
-- vim.keymap.set({ "n", "x" }, "x",              api.fs.cut,                         opts("Cut"))
-- vim.keymap.set("n",          "y",              api.fs.copy.filename,               opts("Copy Name"))
-- vim.keymap.set("n",          "Y",              api.fs.copy.relative_path,          opts("Copy Relative Path"))
-- vim.keymap.set("n",          "<2-LeftMouse>",  api.node.open.edit,                 opts("Open"))
-- vim.keymap.set("n",          "<2-RightMouse>", api.tree.change_root_to_node,       opts("CD"))
-- END_ON_ATTACH_DEFAULT
