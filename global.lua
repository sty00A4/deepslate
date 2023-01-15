---splits the given string by the `sep` seperator string
---@param s string
---@param sep string
---@return table
string.split = function(s, sep)
    local t = {}
    local temp = ""
    local i = 1
    while i <= #s do
        if s:sub(i, i) == sep then
            table.insert(t, temp)
            temp = ""
            i = i + 1
        else
            temp = temp .. s:sub(i, i)
            i = i + 1
        end
    end
    if #temp > 0 then table.insert(t, temp) end
    return t
end
---returns the representation of the value as a string
---@param v any
---@return string
string.repr = function(v)
    if rawtype(v) == "table" then
        local meta = getmetatable(v)
        if meta then
            if type(meta.__tostring) == "function" then
                return tostring(v)
            end
        end
    end
    return string.format("%q", v)
end
---joins all the values in `t` with the `sep` seperator and applies the `f` function to every value
---@param t table
---@param sep string
---@param f function
---@return string
table.joinWith = function(t, sep, f)
    local s = ""
    for _, v in ipairs(t) do
        s = s .. f(v) .. sep
    end
    if #t > 1 then s = s:sub(1, #s-#sep) end
    return s
end
---checks if `v` is contained inside `t`
---@param t table
---@param v any
---@return boolean
table.contains = function(t, v)
    for _, vt in pairs(t) do
        if v == vt then
            return true
        end
    end
    return false
end