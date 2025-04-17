local M = {}

function M.trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.newline_escape(s)
    return s:gsub("\n", "\\n")
end

function M.newline_unescape(s)
    return s:gsub("\\n", "\n")
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
    local suffix = "..."
    local suffix_len = utf8.len(suffix)

    local chars_to_keep = length_limit - suffix_len

    -- NOTE: This case is not happend, but might be handled as a software.
    if chars_to_keep < 1 then
        return "" .. suffix
    end

    local total_len = utf8.len(item)
    if total_len <= chars_to_keep then
        return item
    else
        local eliminated_part = utf8.sub(item, 1, chars_to_keep)
        return eliminated_part .. suffix
    end
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
