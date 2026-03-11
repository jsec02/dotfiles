-- ================================================================================
-- =                                     MAN                                      =
-- ================================================================================

-- Force on signcolumn (built in man.vim turns it off)
vim.opt_local.signcolumn = "yes"

-- Cleanup on filetype change
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. "| setlocal tabstop< softtabstop< shiftwidth< expandtab< autoindent<"
