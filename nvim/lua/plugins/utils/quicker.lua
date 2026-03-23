-- ================================================================================
-- =                                 QUICKER.NVIM                                 =
-- ================================================================================

return {
    "stevearc/quicker.nvim",
    -- enabled = false,
    ft = "qf",
    opts = {
        constrain_cursor = false,
        borders = { vert = "│" },
        opts = {
            number = true,
            relativenumber = true,
        },
    },
}
