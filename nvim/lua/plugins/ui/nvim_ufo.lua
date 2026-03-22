-- ================================================================================
-- =                                   NVIM-UFO                                   =
-- ================================================================================

return {
    "kevinhwang91/nvim-ufo",
    -- enabled = false,
    event = "VeryLazy",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    config = function()
        -- Folding settings
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Keymaps
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

        -- Setup
        require("ufo").setup()
    end,
}
