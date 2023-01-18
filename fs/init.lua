local typed = require "deep.typed"
local fs = { meta = {} }

--- PATH ---
fs.meta.Path = {
    __name = "path",
    __eq = function(self, other)
        if type(other) == "path" then
            return other.path == self.path
        end
        if type(other) == "string" then
            return fs.Path.new(other) == self.path
        end
        return false
    end
}
fs.Path = {
    ---@param path string
    ---@return path
    new = function(path)
        assertType(1, path, "string")
        return setmetatable(
            ---@class path
            { path = path },
            fs.meta.Path
        )
    end
}

--- FILE MODE ---
fs.FileMode = setmetatable({
    write = setmetatable(
        ---@class fileMode
        { string = "w" },
        {
            __name = "fileMode.write",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "write" end
        }
    ),
    read = setmetatable(
        ---@class fileMode
        { string = "r" },
        {
            __name = "fileMode.read",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "read" end
        }
    ),
    append = setmetatable(
        ---@class fileMode
        { string = "a" },
        {
            __name = "fileMode.append",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "append" end
        }
    ),
    writeByte = setmetatable(
        ---@class fileMode
        { string = "wb" },
        {
            __name = "fileMode.write",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "writeByte" end
        }
    ),
    readByte = setmetatable(
        ---@class fileMode
        { string = "rb" },
        {
            __name = "fileMode.read",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "readByte" end
        }
    ),
    appendByte = setmetatable(
        ---@class fileMode
        { string = "ab" },
        {
            __name = "fileMode.append",
            __eq = function (self, other)
                return typed.Type.from(self) == typed.Type.from(other)
            end,
            __tostring = function() return "appendByte" end
        }
    ),
}, {
    __name = "fileMode",
    __newindex = function(t, k, v) error("fileMode is immutable", 2) end
})

--- FILE ---
fs.meta.File = {
    __name = "file",
    __newindex = function(t, k, v) error("file is immutable", 2) end
}
fs.File = {
    ---@param path path|string
    ---@param fmode fileMode
    ---@return file|nil
    open = function(path, fmode)
        assertType(1, path, "path", "string")
        if type(path) == "string" then path = fs.Path.new(path) end
        assertType(2, fmode, "fileMode")
        local file = io.open(path.path, fmode.string) if not file then return nil end
        return setmetatable(
            ---@class file
            {
                __FILE = file,
                path = path, mode = fmode,
                ---@param self file
                close = function(self) return self.__FILE:close() end,
                ---@param self file
                flush = function(self) return self.__FILE:flush() end,
                ---@param self file
                lines = function(self) return self.__FILE:lines() end,
                ---@param self file
                ---@param ... string|integer|"*a"|"*l"|"*n"
                read = function(self, ...) return self.__FILE:read(...) end,
                ---@param self file
                readAll = function(self) return self.__FILE:read("*a") end,
                ---@param self file
                seek = function(self) return self.__FILE:seek() end,
                ---@param self file
                ---@param ... string|number
                write = function(self, ...) return self.__FILE:write(...) end,
                ---@param self file
                ---@param mode "full"|"line"|"no"
                ---@param size? integer
                setvbuf = function(self, mode, size) return self.__FILE:setvbuf(mode, size) end,
            },
            fs.meta.File
        )
    end,
}

return fs