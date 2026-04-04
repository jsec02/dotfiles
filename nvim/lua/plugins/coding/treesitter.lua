-- ================================================================================
-- =                               NVIM-TREESITTER                                =
-- ================================================================================

return {
    "nvim-treesitter/nvim-treesitter",
    -- enabled = false,
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local install_dir = vim.fn.stdpath("data") .. "/site"
        require("nvim-treesitter").setup({
            install_dir = install_dir,
        })
        vim.opt.runtimepath:prepend(install_dir)

        -- Parsers to install (parser names, not filetypes)
        local parsers = {
            "bash",
            "c",
            "css",
            "diff",
            "html",
            "htmldjango",
            "javascript",
            "json",
            "kdl",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "vim",
            "vimdoc",
        }

        -- Filetypes that should activate treesitter
        -- sh filetype uses bash parser, so include it here but not in parsers
        local filetypes = vim.list_extend(vim.deepcopy(parsers), { "sh" })

        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetypes,
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
