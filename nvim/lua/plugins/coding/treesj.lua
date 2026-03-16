-- ================================================================================
-- =                                    TREESJ                                    =
-- ================================================================================

return {
    "Wansmer/treesj",
    -- enabled = false,
    keys = {
        {
            "J",
            function()
                local ok = pcall(vim.treesitter.get_parser)
                if ok then
                    vim.cmd("TSJToggle")
                else
                    vim.api.nvim_feedkeys("J", "n", false)
                end
            end,
            desc = "Join Toggle",
        },
    },
    opts = { use_default_keymaps = false, max_join_length = 2000 },
}
