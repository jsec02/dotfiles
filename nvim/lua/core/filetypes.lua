-- ================================================================================
-- =                                  FILETYPES                                   =
-- ================================================================================

vim.filetype.add({
    extension = {
        sh = "bash",
        zsh = "bash",
    },
    filename = {
        [".zshrc"] = "bash",
        [".zshenv"] = "bash",
        [".zshenv.local"] = "bash",
        [".zprofile"] = "bash",
    },
})
