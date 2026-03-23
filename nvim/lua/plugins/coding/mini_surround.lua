-- ================================================================================
-- =                                MINI.SURROUND                                 =
-- ================================================================================

return {
    "echasnovski/mini.surround",
    -- enabled = false,
    event = "VeryLazy",
    version = "*",
    config = function()
        require("mini.surround").setup({})
    end,
}
