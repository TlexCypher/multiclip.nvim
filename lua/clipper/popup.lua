local popup = require("plenary.popup")
local utils = require("clipper.utils")

local M = {}
M.clipper_win_id = nil
M.clipper_bufh = nil

local function get_displaied_vs_actual_hashmap(displayable, actual)
    local hashmap = {}
    assert(#displayable == #actual, "displayable size is not equal to actual size.")

    for index, value in ipairs(displayable) do
        hashmap[value] = actual[index]
    end
    return hashmap
end


local function create_window(yank_history, config, callback)
    yank_history = yank_history or {}

    local width = config.win_width or 60
    local height = config.win_height or 10
    local borderchars = config.borderchars or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local displayable = utils.make_displayable(yank_history, width)
    local displaied_vs_actual = get_displaied_vs_actual_hashmap(displayable, yank_history:to_list())
    local cb = callback or function(_, value)
        local want = utils.newline_unescape(displaied_vs_actual[value])
        vim.fn.setreg('"', want)
        vim.fn.setreg('0', want)
    end

    local clipper_win_id = popup.create(displayable, {
        title = "Clipper",
        hightlight = "ClipperWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        callback = cb,
    })

    return {
        bufnr = vim.api.nvim_win_get_buf(clipper_win_id),
        win_id = clipper_win_id,
    }
end

function M.toggle_quick_menu(yank_history, config, callback)
    if M.clipper_win_id and vim.api.nvim_win_is_valid(M.clipper_win_id) then
        vim.api.nvim_win_close(M.clipper_win_id, true)
        M.clipper_win_id = nil
        return
    end
    local win_info = create_window(yank_history, config, callback)
    M.clipper_win_id = win_info.win_id
    M.clipper_bufh = win_info.bufnr

    vim.api.nvim_win_set_option(M.clipper_win_id, "number", true)
    vim.api.nvim_buf_set_keymap(M.clipper_bufh, "n", "q",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", M.clipper_win_id), { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(M.clipper_bufh, "n", "<ESC>",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", M.clipper_win_id), { noremap = true, silent = true }
    )
end

return M
