local HashSet = {}

function HashSet:new()
    return setmetatable({ items = {}, size = 0 }, { __index = HashSet })
end

function HashSet:add(value)
    if not HashSet:contains(value) then
        self.items[value] = true
        self.size = self.size + 1
    end
end

function HashSet:remove(value)
    if HashSet:contains(value) then
        self.items[value] = nil
        self.size = self.size - 1
    end
end

function HashSet:contains(value)
    return self[value] ~= nil
end

function HashSet:len()
    return self.size
end

return HashSet
