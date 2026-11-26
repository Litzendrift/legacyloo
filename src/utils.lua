local Utils = {}

---comment
---@param original table
---@return table
function Utils.shallowClone(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

---comment
---@param original table
---@param seen any
---@return table
function Utils.deepClone(original, seen)
    if type(original) ~= "table" then
        return original
    end

    seen = seen or {}
    if seen[original] then
        return seen[original]
    end

    local copy = {}
    seen[original] = copy

    for key, value in pairs(original) do
        copy[Utils.deepClone(key, seen)] = Utils.deepClone(value, seen)
    end

    local metatable = getmetatable(original)
    if metatable then
        setmetatable(copy, Utils.deepClone(metatable, seen))
    end

    return copy
end

---comment
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function Utils.distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

---comment
---@param num number
---@return integer
function Utils.roundToInteger(num)
    return (math.floor(num + 0.5))
end

---comment
---@param mouseX number
---@param mouseY number
---@param x1 number
---@param y2 number
---@param width number
---@param height number
---@return boolean
function Utils.isCoordInBox(mouseX, mouseY, x1, y2, width, height)
    if mouseX >= x1 and mouseX <= x1 + width
        and mouseY >= y2 and mouseY <= y2 + height then
        return true
    end

    return false
end

---comment
---@param value any
---@param indent any
---@param seen any
---@return string
function Utils.dump(value, indent, seen)
    indent = indent or 0
    seen = seen or {}

    if type(value) ~= "table" then
        return tostring(value)
    end

    if seen[value] then
        return "{...}" -- avoids looping on self-referencing tables
    end
    seen[value] = true

    local parts = { "{" }
    for key, item in pairs(value) do
        parts[#parts + 1] = "\n"
            .. string.rep(" ", indent + 2)
            .. "[" .. Utils.dump(key, 0, seen) .. "] = "
            .. Utils.dump(item, indent + 2, seen)
            .. ","
    end
    parts[#parts + 1] = "\n" .. string.rep(" ", indent) .. "}"

    seen[value] = nil
    return table.concat(parts)
end

---comment
---@param t table
---@param value any
---@return integer?
function Utils.findIndex(t, value)
    for i, item in ipairs(t) do
        if item == value then
            return i
        end
    end
    return nil -- not found
end

---comment
---@param degrees number
---@return unknown
function Utils.degreesToRadians(degrees)
    return degrees * math.pi / 180
end

---comment
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function Utils.angle(x1, y1, x2, y2)
    return math.atan2(y2-y1, x2-x1)
end

return Utils
