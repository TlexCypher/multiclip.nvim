local popup = require("multiclip.popup")
local utils = require("multiclip.utils")

local M = {}

M.config = {}
M.yank_history = {}

M.config = {}


M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            local yanked_text = vim.fn.getreg("0")
            table.insert(M.yank_history, 1, utils.trim(yanked_text))
            if #M.yank_history > 50 then
                table.remove(M.yank_history, #M.yank_history)
            end
        end,
    })

    vim.api.nvim_create_user_command("MultiClip", function()
        popup.toggle_quick_menu(M.yank_history)
    end, {})
end

return M
