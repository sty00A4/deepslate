local typed = {}
---@class Type
typed.Type = {
    ---@param path table
    ---@return type.type
    new = function(path)
        if type(path) ~= "table" then
            error("bad argument #1 (expected table, got "..type(path)..")", 2)
        end
        return setmetatable(
            ---@class type.type
            {
                path = path
            },
            {
                __name = "type.type",
                ---@param self type.type
                ---@param other type.type
                ---@return boolean
                __eq = function(self, other)
                    if type(other) == "string" then other = typed.Type.from(other) end
                    if type(other) ~= "type.type" then error("bad argument #1 (expected type.type, got "..type(other)..")", 2) end
                    if #other.path > #self.path then return false end
                    for i = 1, #other.path do
                        if self.path[i] ~= other.path[i] then
                            return false
                        end
                    end
                    return true
                end,
                __tostring = function(self) return table.concat(self.path, ".") end
            }
        )
    end,
    ---@param path string
    ---@return type.type
    from = function(path)
        if type(path) ~= "string" then
            error("bad argument #1 (expected string, got "..type(path)..")", 2)
        end
        return typed.Type.new(path:split("."))
    end,
    ---@param v any
    ---@return type.type
    of = function(v)
        return typed.Type.from(type(v))
    end
}
typed.ValueType = {
    ---@param value any
    ---@return type.valueType
    new = function(value)
        return setmetatable(
            ---@class type.valueType
            {
                value = value
            },
            {
                __name = "type.valueType",
                ---@param self type.valueType
                ---@param other any
                ---@return boolean
                __eq = function(self, other)
                    if type(other) == "type.valueType" then
                        return self.value == other.value
                    end
                    return self.value == other
                end,
                __tostring = function(self) return tostring(self.value) end
            }
        )
    end,
}
typed.Union = {
    ---@param types table
    ---@return type.union
    new = function(types)
        if type(types) ~= "table" then
            error("bad argument #1 (expected table, got "..type(types)..")", 2)
        end
        return setmetatable(
            ---@class type.union
            {
                types = types,
                contains = function(self, v)
                    for _, typ in pairs(self.types) do
                        if typ == v then
                            return true
                        end
                    end
                    return false
                end
            },
            {
                __name = "type.union",
                ---@param self type.union
                ---@param other type.union
                ---@return boolean
                __eq = function(self, other)
                    if type(other) == "type.union" then
                        for _, typ in ipairs(self.types) do
                            if not table.contains(other, typ) then
                                return false
                            end
                        end
                        return true
                    end
                    for _, typ in pairs(self.types) do
                        if typ == other then
                            return true
                        end
                    end
                    return false
                end,
                __tostring = function(self) return table.joinWith(self.types, "|", tostring) end
            }
        )
    end,
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
    local types = {}
    for _, typ in ipairs({...}) do
        table.insert(types, typed.Type.from(typ))
    end
    types = typed.Union.new(types)
    local vType = typed.Type.from(type(v))
    if types:contains(vType) then
        return true
    else
        -- type mismatch
        if type(label) == "number" then
            error("bad argument #"..tostring(label).." (expected "..tostring(types)..", got "..tostring(vType)..")", 3)
        else
            error("bad field "..label.." (expected "..tostring(types)..", got "..tostring(vType)..")", 3)
        end
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
        error("bad argument #"..tostring(label).." (expected "..table.joinWith(values, "|", string.repr)..", got "..type(v)..")", 3)
    else
        error("bad field "..label.." (expected "..table.joinWith(values, "|", string.repr)..", got "..type(v)..")", 3)
    end
end

return typed