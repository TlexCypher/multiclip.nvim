local popup = require("multiclip.popup")
local utils = require("multiclip.utils")
local hashset = require("multiclip.hashset")

local M = {}

M.config = {}
M.yank_history = hashset:new()

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    limit_size = M.config.limit or 10
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            M.yank_history:add(utils.trim(vim.fn.getreg("0")))
            if M.yank_history:len() > limit_size then
                table.remove(M.yank_history, #M.yank_history)
            end
        end,
    })

    vim.api.nvim_create_user_command("MultiClip", function()
        popup.toggle_quick_menu(M.yank_history)
    end, {})
end

return M
