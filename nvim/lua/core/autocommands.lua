-- ================================================================================
-- =                                 AUTOCOMMANDS                                 =
-- ================================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- =============================== EDITOR BEHAVIOR ================================

augroup("editor_behavior", { clear = true })

-- Disable commenting next line
autocmd("FileType", {
    group = "editor_behavior",
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "o" })
    end,
})

-- Restore terminal cursor on exit
autocmd({ "VimLeave", "ExitPre" }, {
    group = "editor_behavior",
    command = "set guicursor=a:ver25",
})

-- Automatically check for external file changes and reload buffers
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = "editor_behavior",
    callback = function()
        if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- Restore cursor position upon entering buffer
autocmd("BufReadPost", {
    group = "editor_behavior",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

-- Open Oil when opening nvim to a directory
vim.api.nvim_create_autocmd("VimEnter", {
    group = "editor_behavior",
    callback = function()
        local arg = vim.fn.argv(0)
        if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
            require("oil").open(arg)
        end
    end,
})

-- Re-run ftplugin after oil.nvim renames a markdown buffer
vim.api.nvim_create_autocmd("BufEnter", {
    group = "editor_behavior",
    pattern = "*.md",
    callback = function()
        vim.cmd("filetype detect")
    end,
})

-- Auto-close buffers when their file is deleted
vim.api.nvim_create_autocmd("FileChangedShell", {
    group = "editor_behavior",
    callback = function(event)
        if vim.fn.filereadable(vim.api.nvim_buf_get_name(event.buf)) == 0 then
            vim.v.fcs_choice = ""
            local buf = event.buf
            vim.schedule(function()
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end)
        else
            vim.v.fcs_choice = "reload"
        end
    end,
})

-- Immediately close command-line history windows (q:, q/, q?)
-- Disabling keymaps doesn't work reliably due to timeoutlen
vim.api.nvim_create_autocmd("CmdwinEnter", {
    group = "editor_behavior",
    callback = function()
        vim.cmd("quit")
    end,
})

-- ============================ UI/VISUAL ENHANCEMENTS ============================

augroup("ui_enhancements", { clear = true })

-- Highlight text on yank
autocmd("TextYankPost", {
    group = "ui_enhancements",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Clear messages on cursor movement
autocmd("CursorMoved", {
    group = "ui_enhancements",
    callback = function()
        vim.cmd("echon ''")
    end,
})

-- Hide diagnostics in insert mode
autocmd("InsertEnter", {
    group = "ui_enhancements",
    callback = function()
        vim.diagnostic.hide(nil, vim.api.nvim_get_current_buf())
    end,
})

-- Show diagnostics when leaving insert mode
autocmd("InsertLeave", {
    group = "ui_enhancements",
    callback = function()
        vim.diagnostic.show(nil, vim.api.nvim_get_current_buf())
    end,
})

-- Auto-balance windows when terminal is resized
autocmd("VimResized", {
    group = "ui_enhancements",
    callback = function()
        vim.cmd("wincmd =")
    end,
})
