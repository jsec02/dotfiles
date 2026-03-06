-- ================================================================================
-- =                                NVIM-AUTOPAIRS                                =
-- ================================================================================

return {
    "windwp/nvim-autopairs",
    -- enabled = false,
    event = "InsertEnter",
    config = function()
        local autopairs = require("nvim-autopairs")
        autopairs.setup({})
        Snacks.toggle({
            name = "Auto Pairing",
            get = function()
                return autopairs.state.disabled == false
            end,
            set = function(state)
                if state then
                    autopairs.enable()
                else
                    autopairs.disable()
                end
            end,
        }):map("<leader>ua")
    end,
}
