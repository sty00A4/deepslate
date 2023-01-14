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
table.joinWith = function(t, sep, f)
    local s = ""
    for _, v in ipairs(t) do
        s = s .. f(v) .. sep
    end
    if #t > 1 then s = s:sub(1, #s-#sep) end
    return s
end

---@class Type
Type = {
    meta = {
        __name = "type",
        __eq = function(self, other)
            if type(other) == "string" then other = Type.new(other) end
            if type(other) ~= "type" then error("expected argument #1 to be type, got "..type(other), 2) end
            if #other.path > #self.path then return false end
            for i = 1, #other.path do
                if self.path[i] ~= other.path[i] then
                    return false
                end
            end
            return true
        end,
        __tostring = function(self) return table.concat(self.path, ".") end
    },
    ---@param typ string
    ---@return Type
    new = function (typ)
        if type(typ) ~= "string" then error("expected argument #1 to be string, got "..tostring(type(typ)), 2) end
        return setmetatable({ path = typ:split("."), type = typ }, Type.meta)
    end,
    ---@param v any
    ---@return Type
    from = function (v)
        return setmetatable({ path = type(v):split("."), type = type(v) }, Type.meta)
    end
}
rawtype = type
---get the type of the given value, if it's a metatable it'll return `__name` if not nil
---@param v any
---@return string
type = function(v)
    if rawtype(v) == "table" then
        local meta = getmetatable(v)
        if meta then
            if meta.__name then
                return tostring(meta.__name)
            end
        end
    end
    return rawtype(v)
end
---throws an error when `v` doesn't match any type given refered to with the `label`
---@param label string|number
---@param v any
---@param ... string
---@return boolean|nil
function assertType(label, v, ...)
    if type(label) ~= "string" and type(label) ~= "number" then return error("expected argument #1 to be string|number, got "..type(label), 2) end
    local types = {...}
    local vType = Type.new(type(v))
    for _, typ in ipairs(types) do
        if vType == Type.new(typ) then
            return true
        end
    end
    -- type mismatch
    if type(label) == "number" then
        error("expected argument #"..tostring(label).." to be "..table.concat(types, "|")..", got "..tostring(vType), 3)
    else
        error("expected "..label.." to be "..table.concat(types, "|")..", got "..tostring(vType), 3)
    end
end
---throws an error when `v` doesn't match any value given refered to with the `label`
---@param label string|number
---@param v any
---@param ... any
---@return boolean|nil
function assertValue(label, v, ...)
    if type(label) ~= "string" and type(label) ~= "number" then return error("expected argument #1 to be string|number, got "..type(label), 2) end
    local values = {...}
    for _, value in ipairs(values) do
        if v == value then
            return true
        end
    end
    -- type mismatch
    if type(label) == "number" then
        error("expected argument #"..tostring(label).." to be "..table.joinWith(values, "|", string.repr)..", got "..tostring(v), 3)
    else
        error("expected "..label.." to be "..table.joinWith(values, "|", string.repr)..", got "..tostring(v), 3)
    end
end