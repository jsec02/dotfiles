-- ================================================================================
-- =                                  FLASH.NVIM                                  =
-- ================================================================================

return {
    "folke/flash.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = {
        prompt = { enabled = false },
        modes = {
            char = {
                enabled = false,
            },
        },
    },
    -- stylua: ignore
    keys = {
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
}
