local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

M.config = {}
M.yank_history = {}

M.config = {}

M.show_yank_history = function()
    pickers.new({}, {
        prompt_title = "Yank History",
        finder = finders.new_table({
            results = M.yank_history
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.fn.setreg('"', selection[1])
                vim.fn.setreg('0', selection[1])
            end)
            return true
        end
    }):find()
end

M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            local yanked_text = vim.fn.getreg("0")
            table.insert(M.yank_history, 1, yanked_text)
            if #M.yank_history > 50 then
                table.remove(M.yank_history, #M.yank_history)
            end
        end,
    })

    vim.api.nvim_create_user_command("MultiClip", function()
        M.show_yank_history()
    end, {})
end

return M
