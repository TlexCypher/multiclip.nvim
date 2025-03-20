local popup = require("multiclip.popup")
local utils = require("multiclip.utils")
local hashset = require("multiclip.hashset")

local M = {}

M.config = {}
M.yank_history = hashset:new()

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
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

    vim.api.nvim_create_user_command("MultiClip", function()
        popup.toggle_quick_menu(M.yank_history, M.config)
    end, {})
end

return M
