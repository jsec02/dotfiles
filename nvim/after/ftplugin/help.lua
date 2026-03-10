-- ================================================================================
-- =                                     HELP                                     =
-- ================================================================================

-- Turn off signcolumn
vim.opt_local.signcolumn = "no"
vim.opt_local.foldcolumn = "1"

-- Cleanup on filetype change
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. "| setlocal tabstop< softtabstop< shiftwidth< expandtab< autoindent<"
