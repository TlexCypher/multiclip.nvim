local popup = require("plenary.popup")
local M = {}

--[[TODO: width, height, borderchars should be configurable.]] --
local function create_window(yank_history)
    yank_history = yank_history or {}

    local width = 60
    local height = 10
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

    local multiclip_win_id = popup.create(yank_history:to_list(), {
        title = "MultiClip",
        hightlight = "MultiClipWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    })

    return {
        bufnr = vim.api.nvim_win_get_buf(multiclip_win_id),
        win_id = multiclip_win_id,
    }
end

function M.toggle_quick_menu(yank_history)
    local win_info = create_window(yank_history)
    multiclip_win_id = win_info.win_id
    multiclip_bufh = win_info.bufnr
    vim.api.nvim_win_set_option(multiclip_win_id, "number", true)
    vim.api.nvim_buf_set_keymap(multiclip_bufh, "n", "q",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", multiclip_win_id), { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(multiclip_bufh, "n", "<ESC>",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", multiclip_win_id), { noremap = true, silent = true }
    )
end

return M
