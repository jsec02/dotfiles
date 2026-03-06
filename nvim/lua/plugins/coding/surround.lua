-- ================================================================================
-- =                                NVIM-SURROUND                                 =
-- ================================================================================

return {
    "kylechui/nvim-surround",
    -- enabled = false,
    enabled = false,
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({})
    end,
}
