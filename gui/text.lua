local typed = require "deepslate.typed"
local Type, Union, ValueType = typed.Type, typed.Union, typed.ValueType
local text = {}

text.Text = {}
text.meta = { __name = "gui.text" }
text.required = {
    text = Type.from("string"), x = Type.from("number"), y = Type.from("number")
}
---@class gui.text
---@field text string
---@field x integer
---@field y integer
---@field fg integer
---@field bg integer
text.default = {
    fg = colors.white, bg = colors.black,
    ---draws the text to the `window`
    ---@param self gui.text
    draw = function(self, window)
        assertType("self", self, "gui.text")
        window.setBackgroundColor(self.bg)
        window.setTextColor(self.fg)
        window.setCursorPos(self.x, self.y)
        window.write(self.text)
    end,
    ---checks if the given `x` and `y` position is over the gui.text `self`
    ---@param self gui.text
    ---@return boolean
    over = function(self, x, y)
        assertType("self", self, "gui.text")
        assertType("x", x, "number")
        assertType("y", y, "number")
        -- todo: height check with `y`
        return x >= self.x and x <= self.x + #self.text - 1 and y == self.y
    end,
}
---@param input table
---@return gui.text
function text.Text.new(input)
    local attrs = table.copy(text.default)
    -- apply default
    for k, v in pairs(attrs) do
        if v and input[k] then
            assertType("input["..tostring(k).."]", input[k], type(v))
        end
        attrs[k] = input[k] or v
    end
    -- apply required
    for k, typ in pairs(text.required) do
        if not getmetatable(typ).__eq(typ, Type.of(input[k])) then
            error("bad argument attrs["..tostring(k).."] (expected "..tostring(typ)..", got "..type(input[k])..")", 2)
        end
        attrs[k] = input[k]
    end
    return setmetatable(attrs, text.meta)
end

return text