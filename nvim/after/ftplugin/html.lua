-- ================================================================================
-- =                                     HTML                                     =
-- ================================================================================

-- Indentation
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true

-- Status column
vim.opt_local.statuscolumn = "%!v:lua.require'custom.modules.status_column'.get()"

-- Line numbers
vim.opt_local.number = true -- Show absolute line numbers
vim.opt_local.relativenumber = true -- Show relative line numbers
vim.opt_local.numberwidth = 4 -- Set line number column width

-- Cleanup on filetype change
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. "| setlocal tabstop< softtabstop< shiftwidth< expandtab< autoindent<"
