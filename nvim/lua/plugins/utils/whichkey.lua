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
        icons = { mappings = false, breadcrumb = "", group = "" },
        defaults = {},
        show_help = true,
        spec = {
            -- Groups
            { "<leader>b", group = "Buffer" },
            { "<leader>c", group = "Code", mode = { "n", "v" } },
            { "<leader>d", group = "Debug" },
            { "<leader>D", group = "Divider" },
            { "<leader>C", group = "Comment" },
            { "<leader>f", group = "File/Find", mode = { "n", "v" } },
            { "<leader>g", group = "Git", mode = { "n", "v" } },
            { "<leader>r", group = "Run" },
            { "<leader>s", group = "Search" },
            { "<leader>t", group = "Test" },
            { "<leader>u", group = "UI/UX" },
            { "<leader>w", group = "Window" },
            { "<leader>T", group = "Tab" },
        },
    },
    config = function(_, opts)
        require("which-key").setup(opts)
    end,
}
