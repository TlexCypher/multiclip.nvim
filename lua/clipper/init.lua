local popup = require("clipper.popup")
local utils = require("clipper.utils")
local hashset = require("clipper.hashset")

local M = {}

M.config = {}
M.yank_history = hashset:new()

M.callback = nil

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    M.callback = M.config.callback

    local limit_size = M.config.limit or 10

    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            local yanked_text = vim.fn.getreg("0")
            local trimmed_text = utils.newline_escape(utils.trim(yanked_text))

            M.yank_history:add(trimmed_text)
            if M.yank_history:len() > limit_size then
                table.remove(M.yank_history, #M.yank_history)
            end
        end,
    })

    vim.api.nvim_create_user_command("Clipper", function()
        popup.toggle_quick_menu(M.yank_history, M.config, M.callback)
    end, {})
end

return M
