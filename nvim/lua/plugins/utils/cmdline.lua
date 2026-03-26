-- ================================================================================
-- =                                 CMDLINE.NVIM                                 =
-- ================================================================================

-- This plugin wipes out visual selections due to redraw
-- https://github.com/neovim/neovim/issues/28510

return {
    "jb49088/cmdline.nvim",
    -- enabled = false,
    opts = {
        hl = {
            substr = "Special",
        },
    },
}
