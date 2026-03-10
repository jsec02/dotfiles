-- ================================================================================
-- =                                   MARKDOWN                                   =
-- ================================================================================

-- Indentation
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- Turn off signcolumn
vim.opt_local.signcolumn = "no"
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.foldcolumn = "1"

-- Text display and editing
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.spell = true

-- Navigate visual lines instead of logical lines
vim.keymap.set("n", "<Down>", "g<Down>", { buffer = true })
vim.keymap.set("n", "<Up>", "g<Up>", { buffer = true })

-- Cleanup on filetype change
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
    .. "| setlocal tabstop< shiftwidth< expandtab< wrap< linebreak< breakindent< spell<"
