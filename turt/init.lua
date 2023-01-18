local turt = {
    meta = {}
}

--- TRANSFORM ---
turt.meta.Position = {
    __name = "position",
    ---@param self position
    ---@param other position
    ---@return boolean
    __eq = function (self, other)
        assertType("left value", self, "position")
        assertType("right value", other, "position")
        return self.x == other.x and self.y == other.y and self.z == other.z
    end
}
turt.Position = {
    ---@param x number
    ---@param y number
    ---@param z number
    ---@return position
    new = function(x, y, z)
        assertType(1, x, "number")
        assertType(2, y, "number")
        assertType(3, z, "number")
        return setmetatable(
            ---@class position
            { x = x, y = y, z = z },
            turt.meta.Position
        )
    end,
    ---@return position
    zero = function()
        return turt.Position.new(0, 0, 0)
    end
}
turt.meta.Direction = {
    __name = "direction",
    __newindex = function(t, k, v) error("Direction is immutable", 2) end,
    ---@param self direction
    ---@param other direction|string
    ---@return boolean
    __eq = function (self, other)
        assertType("left value", self, "direction")
        assertType("right value", other, "direction", "string")
        if type(other) == "string" then
            return self.dir == other
        end
        return self.dir == other.dir
    end
}
turt.Direction = {
    ---comment
    ---@param dir "north"|"south"|"west"|"east"
    ---@return direction
    new = function(dir)
        assertType(1, dir, "string") assertValue(1, dir, "north", "south", "west", "east")
        return setmetatable(
            ---@class direction
            {
                ---@type "north"|"south"|"west"|"east"
                dir = dir,
                ---@param self direction
                ---@param newDir "north"|"south"|"west"|"east"
                set = function(self, newDir)
                    assertType(1, newDir, "string") assertValue(1, newDir, "north", "south", "west", "east")
                    rawset(self, "dir", newDir)
                end,
                ---@param self direction
                left = function(self)
                    if self.dir == "north" then
                        rawset(self, "dir", "west")
                    end
                    if self.dir == "west" then
                        rawset(self, "dir", "south")
                    end
                    if self.dir == "south" then
                        rawset(self, "dir", "east")
                    end
                    if self.dir == "east" then
                        rawset(self, "dir", "north")
                    end
                end,
                ---@param self direction
                right = function(self)
                    if self.dir == "north" then
                        rawset(self, "dir", "east")
                    end
                    if self.dir == "east" then
                        rawset(self, "dir", "south")
                    end
                    if self.dir == "south" then
                        rawset(self, "dir", "west")
                    end
                    if self.dir == "west" then
                        rawset(self, "dir", "north")
                    end
                end,
                ---*east* = `1`, *west* = `-1`, *any other* = `0`
                ---@param self direction
                ---@return integer
                eastward = function(self)
                    if self.dir == "east" then
                        return 1
                    elseif self.dir == "west" then
                        return -1
                    else
                        return 0
                    end
                end,
                ---*south* = `1`, *north* = `-1`, *any other* = `0`
                ---@param self direction
                ---@return integer
                southward = function(self)
                    if self.dir == "south" then
                        return 1
                    elseif self.dir == "north" then
                        return -1
                    else
                        return 0
                    end
                end,
            },
            turt.meta.Direction
        )
    end
}
turt.meta.Transform = {
    __name = "transform",
    ---@param self transform
    ---@param other transform
    ---@return boolean
    __eq = function (self, other)
        assertType("left value", self, "transform")
        assertType("right value", other, "transform")
        return self.pos == other.pos and self.dir == other.dir
    end
}
turt.Transform = {
    ---@param pos position
    ---@param dir direction
    ---@return transform
    new = function(pos, dir)
        assertType(1, pos, "position")
        assertType(2, dir, "direction")
        return setmetatable(
            ---@class transform
            {
                pos = pos, dir = dir,
                ---moves the transform position `pos` forward depending on the direction `dir`
                ---@param self transform
                forward = function(self)
                    self.pos.x = self.pos.x + self.dir:eastward()
                    self.pos.z = self.pos.x + self.dir:southward()
                end,
                ---moves the transform position `pos` backward depending on the direction `dir`
                ---@param self transform
                back = function(self)
                    self.pos.x = self.pos.x - self.dir:eastward()
                    self.pos.z = self.pos.x - self.dir:southward()
                end,
                ---moves the transform position `pos` upward
                ---@param self transform
                up = function(self)
                    self.pos.y = self.pos.y + 1
                end,
                ---moves the transform position `pos` downward
                ---@param self transform
                down = function(self)
                    self.pos.y = self.pos.y - 1
                end,
                ---turns the transform direction `dir` left
                ---@param self transform
                left = function(self)
                    self.dir:left()
                end,
                ---turns the transform direction `dir` right
                ---@param self transform
                right = function(self)
                    self.dir:right()
                end,
            },
            turt.meta.Transform
        )
    end,
    ---@param x number
    ---@param y number
    ---@param z number
    ---@param dir "north"|"south"|"west"|"east"
    ---@return transform
    from = function(x, y, z, dir)
        assertType(1, x, "number")
        assertType(2, y, "number")
        assertType(3, z, "number")
        local pos = turt.Position.new(x, y, z)
        assertType(4, dir, "string") assertValue(4, dir, "north", "south", "west", "east")
        local dir = turt.Direction.new(dir)
        return turt.Transform.new(pos, dir)
    end,
    ---@return transform
    default = function()
        return turt.Transform.new(turt.Position.zero(), turt.Direction.new("north"))
    end
}

--- TURTLE ---
turt.meta.Turtle = {
    __name = "turtle"
}
turt.Turtle = {
    ---@return turtle|nil
    init = function()
        if not turtle then return nil end
        return setmetatable(
            ---@class turtle
            {
                originSet = false,
                origin = turt.Transform.default(), pos = turt.Transform.default(),
                ---moves the turtle forward
                ---@param self turtle
                forward = function(self)
                    self.pos:forward()
                    turtle.forward()
                end,
                ---moves the turtle backward
                ---@param self turtle
                back = function(self)
                    self.pos:back()
                    turtle.back()
                end,
                ---moves the turtle upward
                ---@param self turtle
                up = function(self)
                    self.pos:up()
                    turtle.up()
                end,
                ---moves the turtle downward
                ---@param self turtle
                down = function(self)
                    self.pos:down()
                    turtle.down()
                end,
                ---turns the turtle left
                ---@param self turtle
                left = function(self)
                    self.pos:left()
                    turtle.turnLeft()
                end,
                ---turns the turtle right
                ---@param self turtle
                right = function(self)
                    self.pos:right()
                    turtle.turnRight()
                end,
                ---!!! TODO: all the turtle functions !!!---
            },
            turt.meta.Turtle
        )
    end
}
return turt