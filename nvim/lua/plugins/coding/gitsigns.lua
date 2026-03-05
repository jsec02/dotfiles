-- ================================================================================
-- =                                GITSIGNS.NVIM                                 =
-- ================================================================================

return {
    "lewis6991/gitsigns.nvim",
    -- enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
        Snacks.toggle({
            name = "Git Signs",
            get = function()
                return require("gitsigns.config").config.signcolumn
            end,
            set = function(state)
                require("gitsigns").toggle_signs(state)
                if state then
                    require("gitsigns").refresh()
                end
            end,
        }):map("<leader>ug")

        return {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▎" },
                topdelete = { text = "▎" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▎" },
                topdelete = { text = "▎" },
                changedelete = { text = "▎" },
            },
            attach_to_untracked = true,
            update_debounce = 100,
            on_attach = function(_)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { desc = desc })
                end
                -- stylua: ignore start
                map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next Hunk")
                map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev Hunk")
                map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
                map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
                map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk")
                map("n", "<leader>gl", function() gs.blame_line() end, "Blame Line")
                map("n", "<leader>gL", function() gs.blame_line({ full = true }) end, "Blame Line Full")
            end,
        }
    end,
}
