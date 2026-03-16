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

        local indent_disabled = {
            bash = true,
        }

        require("nvim-treesitter").install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = parsers,
            callback = function()
                vim.treesitter.start()
                if not indent_disabled[vim.bo.filetype] then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
