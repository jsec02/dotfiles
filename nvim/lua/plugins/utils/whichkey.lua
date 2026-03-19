-- ================================================================================
-- =                                WHICH-KEY.NVIM                                =
-- ================================================================================

return {
    "folke/which-key.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = {
        preset = "helix",
        delay = 0,
        sort = { "group", "alphanum", "lower" },
        icons = { mappings = false, group = "" },
        defaults = {},
        show_help = true,
        spec = {
            -- Groups
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code", mode = { "n", "v" } },
            { "<leader>d", group = "Debug" },
            { "<leader>i", group = "Insert" },
            { "<leader>f", group = "File/Find", mode = { "n", "v" } },
            { "<leader>g", group = "Git", mode = { "n", "v" } },
            { "<leader>r", group = "Run" },
            { "<leader>s", group = "Search" },
            { "<leader>t", group = "Test" },
            { "<leader>u", group = "UI/UX" },
            { "<leader>w", group = "Window" },
        },
    },
    config = function(_, opts)
        require("which-key").setup(opts)
    end,
}
