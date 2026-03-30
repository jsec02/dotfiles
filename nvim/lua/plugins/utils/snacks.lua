-- ================================================================================
-- =                                 SNACKS.NVIM                                  =
-- ================================================================================

return {
    "folke/snacks.nvim",
    -- enabled = false,
    priority = 1000,
    lazy = false,
    opts = {
        --- BIGFILE ---
        bigfile = {
            enabled = true,
            setup = function(ctx)
                -- Keep all the default optimizations except statuscolumn manipulation
                if vim.fn.exists(":NoMatchParen") ~= 0 then
                    vim.cmd([[NoMatchParen]])
                end
                Snacks.util.wo(0, { foldmethod = "manual", conceallevel = 0 })
                vim.b.minianimate_disable = true
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(ctx.buf) then
                        vim.bo[ctx.buf].syntax = ctx.ft
                    end
                end)
            end,
        },

        --- BUFDELETE ---
        bufdelete = { enabled = true },

        --- INDENT ---
        indent = {
            enabled = false,
            scope = {
                enabled = false,
            },
        },

        --- LAZYGIT ---
        lazygit = { enabled = true },

        --- NOTIFIER ---
        notifier = { enabled = true },

        --- PICKER ---
        picker = (function()
            -- Get MiniIcons LSP configuration if available
            local has_miniicons, miniicons = pcall(require, "mini.icons")
            local kinds = {}

            if has_miniicons then
                -- Map MiniIcons LSP kind names to Snacks Picker's expected names
                local kind_mapping = {
                    array = "Array",
                    boolean = "Boolean",
                    class = "Class",
                    color = "Color",
                    constant = "Constant",
                    constructor = "Constructor",
                    enum = "Enum",
                    enummember = "EnumMember",
                    event = "Event",
                    field = "Field",
                    file = "File",
                    ["function"] = "Function",
                    interface = "Interface",
                    key = "Key",
                    keyword = "Keyword",
                    method = "Method",
                    module = "Module",
                    namespace = "Namespace",
                    null = "Null",
                    number = "Number",
                    object = "Object",
                    operator = "Operator",
                    package = "Package",
                    property = "Property",
                    reference = "Reference",
                    snippet = "Snippet",
                    string = "String",
                    struct = "Struct",
                    text = "Text",
                    typeparameter = "TypeParameter",
                    unit = "Unit",
                    value = "Value",
                    variable = "Variable",
                }

                -- Extract icons from MiniIcons
                for mini_kind, snacks_kind in pairs(kind_mapping) do
                    local icon = miniicons.get("lsp", mini_kind)
                    if icon then
                        kinds[snacks_kind] = icon
                    end
                end
            end

            return {
                enabled = true,
                layouts = {
                    default = {
                        layout = {
                            backdrop = false,
                        },
                    },
                    select = {},
                },
                win = {
                    preview = {
                        wo = {
                            statuscolumn = " ",
                            signcolumn = "no",
                            number = false,
                            wrap = false,
                        },
                    },
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "i", "n" } },
                        },
                    },
                },
                icons = {
                    kinds = kinds, -- Will use MiniIcons glyphs or fall back to defaults
                },
                sources = {
                    buffers = {
                        sort_lastused = false,
                    },
                    command_history = {
                        layout = { preset = "select" },
                    },
                    search_history = {
                        layout = { preset = "select" },
                    },
                    icons = {
                        layout = { preset = "select" },
                    },
                },
            }
        end)(),
    },
    -- stylua: ignore
    keys = {
        -- top pickers & explorer
        { "<leader><space>", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.lines({ layout = "select", on_show = function() end, title = "Current Buffer Fuzzy" }) end, desc = "Fuzzy Current Buffer" },
        -- { "<leader>q", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        -- { "<leader>l", function() Snacks.picker.loclist() end, desc = "Location List" },
        -- buffer
        { "<leader>bc", function() Snacks.bufdelete() end, desc = "Close Buffer" },
        -- find
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), title = "Config Files" }) end, desc = "Config Files" },
        { "<leader>fe", function() Snacks.explorer() end, desc = "File Explorer" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
        { "<leader>fF", function() Snacks.picker.files({ hidden = true }) end, desc = "All Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Browse" },
        { "<leader>gc", function() Snacks.picker.git_log({ cwd = vim.fs.root(0, ".git") }) end, desc = "Commits" },
        { "<leader>gC", function() Snacks.picker.git_log_file() end, desc = "Commits File" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Diff" },
        { "<leader>gg", function() Snacks.lazygit({ cwd = vim.fn.fnamemodify(vim.fn.finddir('.git', '.;'), ':h') }) end, desc = "Lazygit" },
        { "<leader>gt", function() Snacks.picker.git_status() end, desc = "Status" },
        { "<leader>gT", function() Snacks.picker.git_stash() end, desc = "Stash" },
        -- Grep
        { "<leader>fb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep Files" },
        { "<leader>fG", function() Snacks.picker.grep() end, desc = "Grep All Files" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep Selection/Word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>s'", function() Snacks.picker.marks() end, desc = "Marks" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>s:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sm", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>sp", function() Snacks.picker.pickers() end, desc = "Pickers" },
        { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        -- other
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    },
    config = function(_, opts)
        require("snacks").setup(opts)

        vim.g.snacks_animate = false -- Disable snacks animations

        -- toggles
        -- stylua: ignore start
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map( "<leader>uc")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("relativenumber", { name = "Relative Line Numbers" }):map("<leader>uL")
        Snacks.toggle.option("wrap", { name = "Line Wrapping" }):map("<leader>uw")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle.indent():map("<leader>ui")
        Snacks.toggle.option("spell", { name = "Spell Check" }):map("<leader>us")
        Snacks.toggle.treesitter({ name = "Treesitter Highlighting" }):map("<leader>ut")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        -- stylua: ignore end
    end,
}
