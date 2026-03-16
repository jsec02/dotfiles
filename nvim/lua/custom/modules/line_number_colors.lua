-- ================================================================================
-- =                           LINE_NUMBER_COLORS                                 =
-- ================================================================================

local colors = {
    "#ff6b6b",
    "#ffa06b",
    "#ffd93d",
    "#c9f76f",
    "#6bcf7f",
    "#4ecdc4",
    "#45b7d1",
    "#6b9fff",
    "#a06bff",
    "#d16bff",
    "#ff6bd1",
    "#ff6b9f",
    "#ff8a6b",
    "#ffb86b",
    "#ffe66b",
    "#b8ff6b",
    "#6bff8a",
    "#6bffcc",
    "#6be0ff",
    "#6bb8ff",
}

for i, color in ipairs(colors) do
    vim.api.nvim_set_hl(0, "LineNumberColor" .. i, { fg = color, bold = true })
end

local ns = vim.api.nvim_create_namespace("line_number_colors")

local ids = {}

local function render()
    local buf = vim.api.nvim_get_current_buf()
    local first = vim.fn.line("w0")
    local last = vim.fn.line("w$")
    for lnum = first, last do
        local color_idx = ((lnum - 1) % #colors) + 1
        if ids[lnum] then
            pcall(vim.api.nvim_buf_del_extmark, buf, ns, ids[lnum])
        end
        ids[lnum] = vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
            number_hl_group = "LineNumberColor" .. color_idx,
            priority = 100,
        })
    end
    for lnum, id in pairs(ids) do
        if lnum < first or lnum > last then
            pcall(vim.api.nvim_buf_del_extmark, buf, ns, id)
            ids[lnum] = nil
        end
    end
end

local group = vim.api.nvim_create_augroup("LineNumberColors", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
    group = group,
    callback = render,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function()
        ids = {}
        render()
    end,
})

render()
