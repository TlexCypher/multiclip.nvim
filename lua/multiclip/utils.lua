local utf8 = require("lua-utf8")

local M = {}

function M.trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.newline_escape(s)
    return s:gsub("\n", "\\n")
end

--[[
-- input:
--  var: item
--  type: string
--
--  var: length_limit
--  type: integer
--
--  To handle Japanese and other special characters, we need to handle multi-byte.
--]] --
local function eliminates(item, length_limit)
    local eliminated = ""
    local suffix = "..."
    for _, codepoint in utf8.codepoint(item) do
        local char = utf8.char(codepoint)
        if #eliminated + #suffix + 1 > length_limit then
            break
        end
        eliminated = eliminated .. char
    end
    return eliminated + suffix
end

--[[
-- NOTE:
-- When using plenary.nvim as UI library, max width is not useful.
-- So, if items would be longer than max width, library needs to wrap or eliminates it.
-- make_displayable() is responsible for this.
--
--
-- input:
    -- var: yank_history
    -- type: list
-- ]] --
function M.make_displayable(yank_history, max_width)
    local displayable = {}
    for yh, _ in pairs(yank_history.items) do
        local item = yh
        if #item > max_width then
            item = eliminates(item, max_width)
        end
        table.insert(displayable, item)
    end
    return displayable
end

return M
