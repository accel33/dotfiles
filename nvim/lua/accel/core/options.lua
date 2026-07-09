-- Neovim 0.12: silenciar el ruido de deprecación de plugins que aún no soportan
-- la API nueva (Telescope, nvim-cmp, etc.). Tu propia config ya está modernizada.
-- Quita este bloque cuando esos plugins se actualicen para 0.12.
vim.deprecate = function() end
local _notify = vim.notify
vim.notify = function(msg, ...)
  if type(msg) == "string" and (msg:find("deprecated", 1, true) or msg:find("position_encoding", 1, true)) then
    return
  end
  return _notify(msg, ...)
end

vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, asumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight coloscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace 
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position 

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- no continuar comentarios automáticamente:
--   o = al abrir línea con o/O sobre un comentario  ·  r = al dar Enter dentro de uno
-- (autocmd porque muchos ftplugins re-activan formatoptions al abrir cada archivo)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "o", "r" })
  end,
})



