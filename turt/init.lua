local turt = {
    meta = {}
}

turt.meta.Position = {
    __name = "position",
    ---@param self Position
    ---@param other Position
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
    ---@return Position
    new = function(x, y, z)
        assertType(1, x, "number")
        assertType(2, y, "number")
        assertType(3, z, "number")
        return setmetatable(
            ---@class Position
            { x = x, y = y, z = z },
            turt.meta.Position
        )
    end,
    ---@return Position
    zero = function()
        return turt.Position.new(0, 0, 0)
    end
}
turt.meta.Direction = {
    __name = "direction",
    __newindex = function() error("Direction is immutable", 2) end,
    ---@param self Direction
    ---@param other Direction|string
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
    ---@return Direction
    new = function(dir)
        assertType(1, dir, "string") assertValue(1, dir, "north", "south", "west", "east")
        return setmetatable(
            ---@class Direction
            {
                ---@type "north"|"south"|"west"|"east"
                dir = dir,
                ---@param self Direction
                ---@param newDir "north"|"south"|"west"|"east"
                set = function(self, newDir)
                    assertType(1, newDir, "string") assertValue(1, newDir, "north", "south", "west", "east")
                    rawset(self, "dir", newDir)
                end,
                ---@param self Direction
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
                ---@param self Direction
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
                ---@param self Direction
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
                ---@param self Direction
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
    ---@param self Transform
    ---@param other Transform
    ---@return boolean
    __eq = function (self, other)
        assertType("left value", self, "transform")
        assertType("right value", other, "transform")
        return self.pos == other.pos and self.dir == other.dir
    end
}
turt.Transform = {
    ---@param pos Position
    ---@param dir Direction
    ---@return Transform
    new = function(pos, dir)
        assertType(1, pos, "position")
        assertType(2, dir, "direction")
        return setmetatable(
            ---@class Transform
            {
                pos = pos, dir = dir,
                ---moves the transform position `pos` forward depending on the direction `dir`
                ---@param self Transform
                forward = function(self)
                    self.pos.x = self.pos.x + self.dir:eastward()
                    self.pos.z = self.pos.x + self.dir:southward()
                end,
                ---moves the transform position `pos` backward depending on the direction `dir`
                ---@param self Transform
                back = function(self)
                    self.pos.x = self.pos.x - self.dir:eastward()
                    self.pos.z = self.pos.x - self.dir:southward()
                end,
                ---moves the transform position `pos` upward
                ---@param self Transform
                up = function(self)
                    self.pos.y = self.pos.y + 1
                end,
                ---moves the transform position `pos` downward
                ---@param self Transform
                down = function(self)
                    self.pos.y = self.pos.y - 1
                end,
                ---turns the transform direction `dir` left
                ---@param self Transform
                left = function(self)
                    self.dir:left()
                end,
                ---turns the transform direction `dir` right
                ---@param self Transform
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
    ---@return Transform
    from = function(x, y, z, dir)
        assertType(1, x, "number")
        assertType(2, y, "number")
        assertType(3, z, "number")
        local pos = turt.Position.new(x, y, z)
        assertType(4, dir, "string") assertValue(4, dir, "north", "south", "west", "east")
        dir = turt.Direction.new(dir)
        return turt.Transform.new(pos, dir)
    end,
    ---@return Transform
    default = function()
        return turt.Transform.new(turt.Position.zero(), turt.Direction.new("north"))
    end
}

turt.meta.Turtle = {
    __name = "turtle"
}
turt.Turtle = {
    ---@return Turtle|nil
    init = function()
        if not turtle then return nil end
        return setmetatable(
            ---@class Turtle
            {
                originSet = false,
                origin = turt.Transform.default(), pos = turt.Transform.default(),
                ---moves the turtle forward
                ---@param self Turtle
                forward = function(self)
                    self.pos:forward()
                    turtle.forward()
                end,
                ---moves the turtle backward
                ---@param self Turtle
                back = function(self)
                    self.pos:back()
                    turtle.back()
                end,
                ---moves the turtle upward
                ---@param self Turtle
                up = function(self)
                    self.pos:up()
                    turtle.up()
                end,
                ---moves the turtle downward
                ---@param self Turtle
                down = function(self)
                    self.pos:down()
                    turtle.down()
                end,
                ---turns the turtle left
                ---@param self Turtle
                left = function(self)
                    self.pos:left()
                    turtle.turnLeft()
                end,
                ---turns the turtle right
                ---@param self Turtle
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