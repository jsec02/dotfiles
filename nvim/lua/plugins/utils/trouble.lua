-- ================================================================================
-- =                                 TROUBLE.NVIM                                 =
-- ================================================================================

return {
    "folke/trouble.nvim",
    -- enabled = false,
    cmd = { "Trouble" },
    opts = function()
        -- Get MiniIcons LSP configuration if available
        local has_miniicons, miniicons = pcall(require, "mini.icons")
        local kinds = {}
        local highlight_links = {}

        if has_miniicons then
            -- Map MiniIcons LSP kind names to Trouble's expected names
            local kind_mapping = {
                array = "Array",
                boolean = "Boolean",
                class = "Class",
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
                method = "Method",
                module = "Module",
                namespace = "Namespace",
                null = "Null",
                number = "Number",
                object = "Object",
                operator = "Operator",
                package = "Package",
                property = "Property",
                string = "String",
                struct = "Struct",
                typeparameter = "TypeParameter",
                variable = "Variable",
            }

            -- Extract icons and highlight groups from MiniIcons using correct API
            for mini_kind, trouble_kind in pairs(kind_mapping) do
                local icon, hl = miniicons.get("lsp", mini_kind)
                if icon then
                    kinds[trouble_kind] = icon
                    highlight_links["TroubleIcon" .. trouble_kind] = hl
                end
            end
        end

        return {
            modes = {
                lsp_base = {
                    auto_jump = false,
                    params = {
                        include_current = false,
                    },
                },
                lsp_definitions = { auto_jump = false },
                lsp_declarations = { auto_jump = false },
                lsp_references = { auto_jump = false },
                lsp_implementations = { auto_jump = false },
                lsp_type_definitions = { auto_jump = false },
            },
            icons = {
                kinds = kinds, -- Will use MiniIcons glyphs or fall back to defaults
            },
            _miniicons_highlights = highlight_links, -- Store for use in config function
        }
    end,
    config = function(_, opts)
        -- Set up the plugin with the options
        require("trouble").setup(opts)

        -- Apply MiniIcons highlight links if available
        if opts._miniicons_highlights then
            for trouble_hl, miniicons_hl in pairs(opts._miniicons_highlights) do
                vim.api.nvim_set_hl(0, trouble_hl, { link = miniicons_hl })
            end
        end
    end,
    keys = {
        { "<leader>l", "<Cmd>Trouble loclist toggle<CR>", desc = "Location List" },
        { "<leader>q", "<Cmd>Trouble qflist toggle<CR>", desc = "Quickfix List" },
        { "<leader>cd", "<Cmd>Trouble lsp_definitions toggle<CR>", desc = "Definitions" },
        { "<leader>cD", "<Cmd>Trouble lsp_declarations toggle<CR>", desc = "Declarations" },
        { "<leader>ct", "<Cmd>Trouble lsp_type_definitions toggle<CR>", desc = "Type Definitions" },
        { "<leader>ci", "<Cmd>Trouble lsp_implementations toggle<CR>", desc = "Implementations" },
        { "<leader>cx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
        { "<leader>cs", "<Cmd>Trouble lsp_document_symbols toggle<CR>", desc = "Symbols" },
        { "<leader>cr", "<Cmd>Trouble lsp_references toggle<CR>", desc = "References" },
        {
            "[q",
            function()
                if require("trouble").is_open() then
                    require("trouble").prev({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Previous Trouble/Quickfix Item",
        },
        {
            "]q",
            function()
                if require("trouble").is_open() then
                    require("trouble").next({ skip_groups = true, jump = true })
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end,
            desc = "Next Trouble/Quickfix Item",
        },
    },
}
