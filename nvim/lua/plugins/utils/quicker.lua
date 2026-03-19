-- ================================================================================
-- =                                 QUICKER.NVIM                                 =
-- ================================================================================

return {
    "stevearc/quicker.nvim",
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
