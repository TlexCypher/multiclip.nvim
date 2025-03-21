local popup = require("clipper.popup")

local M = {}

M.config = {}

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    M.callback = M.config.callback
    popup.register_yank_history(M.config)
    vim.api.nvim_create_user_command("Clipper", function()
        popup.toggle_quick_menu(M.config, M.callback)
    end, {})
end

return M
