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

-- Save view when leaving buffer or writing (cursor position, folds, etc.)
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
    group = "editor_behavior",
    callback = function(args)
        if vim.b[args.buf].view_activated then
            vim.cmd.mkview({ mods = { emsg_silent = true } })
        end
    end,
})

-- Restore view when entering buffer
autocmd("BufWinEnter", {
    group = "editor_behavior",
    callback = function(args)
        if not vim.b[args.buf].view_activated then
            local buftype = vim.bo[args.buf].buftype
            local filetype = vim.bo[args.buf].filetype
            local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }

            if buftype == "" and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                vim.b[args.buf].view_activated = true
                vim.cmd.loadview({ mods = { emsg_silent = true } })
            end
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

-- Restore ftplugin window-local options after snacks picker preview
-- Fixes instances where no line numbers are present on buffer
autocmd("BufWinEnter", {
    group = "editor_behavior",
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local win = vim.api.nvim_get_current_win()
        if ft == "" or vim.w[win].snacks_picker_preview then
            return
        end
        vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then
                return
            end
            vim.api.nvim_win_call(win, function()
                vim.api.nvim_exec_autocmds("FileType", { pattern = ft, modeline = false })
            end)
        end)
    end,
})

-- Correct cursor position when leaving visual block mode with virtualedit=block
-- Without this, the cursor can get stuck in a virtual column past EOL
vim.api.nvim_create_autocmd("ModeChanged", {
    group = "editor_behavior",
    pattern = "*:n",
    callback = function()
        local col = vim.fn.col(".")
        local eol = vim.fn.col("$")
        if col >= eol then
            vim.cmd("normal! $")
        end
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
