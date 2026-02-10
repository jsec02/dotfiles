-- ================================================================================
-- =                                VIM-ILLUMINATE                                =
-- ================================================================================

return {
    "RRethy/vim-illuminate",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        delay = 200,
        providers = { "lsp", "treesitter", "regex" },
        filetypes_denylist = {
            "bigfile",
            "snacks_picker_list",
            "snacks_picker_preview",
            "snacks_picker_input",
            "oil",
            "noice",
        },
    },
    config = function(_, opts)
        local illuminate = require("illuminate")
        illuminate.configure(opts)

        local enabled = false

        Snacks.toggle({
            name = "Underlines",
            get = function()
                return enabled
            end,
            set = function(state)
                enabled = state
                if enabled then
                    illuminate.resume()
                else
                    illuminate.pause()
                end
            end,
        }):map("<leader>uu")

        illuminate.pause()

        -- turn off in inactive windows
        vim.api.nvim_create_autocmd("WinLeave", {
            callback = function()
                if enabled then
                    illuminate.pause()
                end
            end,
        })
        vim.api.nvim_create_autocmd("WinEnter", {
            callback = function()
                if enabled then
                    illuminate.resume()
                end
            end,
        })
    end,
}
