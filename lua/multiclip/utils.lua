local M = {}

function M.trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.newline_escape(s)
    return s:gsub("\n", "\\n")
end

return M
