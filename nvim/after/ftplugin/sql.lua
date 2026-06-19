-- ================================================================================
-- =                                     SQL                                      =
-- ================================================================================

local runner = require("custom.modules.runner")

-- Indentation
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true

local function get_sql_config(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
    local config = {}

    for _, line in ipairs(lines) do
        local dbms = line:match("^%-%-%s*dbms:%s*(%S+)")
        local user = line:match("^%-%-%s*user:%s*(%S+)")
        if dbms then
            config.dbms = dbms
        end
        if user then
            config.user = user
        end
    end

    return config
end

local function build_sql_command(config, filename)
    local commands = {
        mariadb = { "mariadb", "-u", config.user, "-t", "-e", string.format('"source %s"', filename) },
        mysql = { "mysql", "-u", config.user, "-t", "-e", string.format('"source %s"', filename) },
    }
    return commands[config.dbms]
end

local function run_sql(run_func, bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local config = get_sql_config(bufnr)

    if not config.dbms then
        vim.notify("SQL runner: missing '-- dbms: <dbms>' comment", vim.log.levels.ERROR)
        return
    end

    if not config.user then
        vim.notify("SQL runner: missing '-- user: <user>' comment", vim.log.levels.ERROR)
        return
    end

    local cmd = build_sql_command(config, filename)

    if not cmd then
        vim.notify("SQL runner: unsupported dbms '" .. config.dbms .. "'", vim.log.levels.ERROR)
        return
    end

    run_func(cmd, filename)
end

-- Run keymaps
vim.keymap.set("n", "<leader>rr", function()
    run_sql(function(cmd)
        runner.run_shell_in_zellij(table.concat(cmd, " "))
    end, 0)
end, { buffer = true, desc = "Run SQL" })

vim.keymap.set("n", "<leader>rf", function()
    run_sql(function(cmd)
        runner.run_shell_in_zellij_floating(table.concat(cmd, " "))
    end, 0)
end, { buffer = true, desc = "Run SQL (Floating)" })

-- Cleanup on filetype change
vim.b.undo_ftplugin = (vim.b.undo_ftplugin ~= "" and vim.b.undo_ftplugin .. " | " or "")
    .. "setlocal tabstop< softtabstop< shiftwidth< expandtab< autoindent<"
