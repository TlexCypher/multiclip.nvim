local popup = require("plenary.popup")
local utils = require("clipper.utils")
local hashset = require("clipper.hashset")

local M = {}
M.clipper_win_id = nil
M.clipper_bufh = nil
M.displaied_vs_actual = nil
M.dispalyable_width = nil
M.yank_history = hashset:new()
M.callback = nil


local function get_displaied_vs_actual_hashmap(displayable, actual)
    local hashmap = {}
    assert(#displayable == #actual, "displayable size is not equal to actual size.")
    for index, value in ipairs(displayable) do
        hashmap[value] = actual[index]
    end
    return hashmap
end

local function create_window(_yank_history, config, callback)
    local yank_history = _yank_history or {}
    local width = config.win_width or 60
    local height = config.win_height or 10
    local borderchars = config.borderchars or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local displayable = utils.make_displayable(yank_history, width)

    M.dispalyable_width = width
    M.displaied_vs_actual = get_displaied_vs_actual_hashmap(displayable, yank_history:to_list())

    local cb = callback or function(_, value)
        local want = utils.newline_unescape(M.displaied_vs_actual[value])
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

local function track_popup_changes(yank_history)
    local yank_history_list = yank_history:to_list()

    if vim.v.event.operator == "d" then
        local deleted_text = utils.newline_escape(utils.trim(vim.fn.getreg('"')))
        for index, value in ipairs(yank_history_list) do
            if utils.newline_escape(utils.make_displayable_text(value, M.dispalyable_width)) == deleted_text then
                table.remove(yank_history_list, index)
                break
            end
        end
    end

    return yank_history_list
end

local function build_yank_history(source)
    local new_yank_history = hashset:new()
    for _, value in ipairs(source) do
        new_yank_history:add(value)
    end
    return new_yank_history
end

function M.register_yank_history(config)
    local limit_size = config.limit or 10
    local yank_only = config.yank_only or true
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            if yank_only and vim.v.event.operator ~= "y" then
                return
            end
            local yanked_text = vim.fn.getreg("0")
            local trimmed_text = utils.newline_escape(utils.trim(yanked_text))

            M.yank_history:add(trimmed_text)
            if M.yank_history:len() > limit_size then
                table.remove(M.yank_history, #M.yank_history)
            end
        end,
    })
end

function M.toggle_quick_menu(config, callback)
    if M.clipper_win_id and vim.api.nvim_win_is_valid(M.clipper_win_id) then
        vim.api.nvim_win_close(M.clipper_win_id, true)
        M.clipper_win_id = nil
        return
    end
    local win_info = create_window(M.yank_history, config, callback)
    M.clipper_win_id = win_info.win_id
    M.clipper_bufh = win_info.bufnr

    vim.api.nvim_win_set_option(M.clipper_win_id, "number", true)
    vim.api.nvim_buf_set_keymap(M.clipper_bufh, "n", "q",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", M.clipper_win_id), { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(M.clipper_bufh, "n", "<ESC>",
        string.format(":lua vim.api.nvim_win_close(%d, true)<CR>", M.clipper_win_id), { noremap = true, silent = true }
    )
    vim.api.nvim_create_autocmd("TextYankPost", {
        buffer = M.clipper_bufh,
        callback = function()
            local new_yank_history_list = track_popup_changes(M.yank_history)
            M.yank_history = build_yank_history(new_yank_history_list)
        end
    })
end

return M
