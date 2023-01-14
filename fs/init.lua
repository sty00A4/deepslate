require "deep.global"
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
    ---@return Path
    new = function(path)
        assertType(1, path, "string")
        return setmetatable(
            ---@class Path
            { path = path },
            fs.meta.Path
        )
    end
}

--- FILE MODE ---
fs.FileMode = setmetatable({
    write = setmetatable(
        ---@class FileMode
        { string = "w" },
        {
            __name = "fileMode.write",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "write" end
        }
    ),
    read = setmetatable(
        ---@class FileMode
        { string = "r" },
        {
            __name = "fileMode.read",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "read" end
        }
    ),
    append = setmetatable(
        ---@class FileMode
        { string = "a" },
        {
            __name = "fileMode.append",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "append" end
        }
    ),
    writeByte = setmetatable(
        ---@class FileMode
        { string = "wb" },
        {
            __name = "fileMode.write",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "writeByte" end
        }
    ),
    readByte = setmetatable(
        ---@class FileMode
        { string = "rb" },
        {
            __name = "fileMode.read",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "readByte" end
        }
    ),
    appendByte = setmetatable(
        ---@class FileMode
        { string = "ab" },
        {
            __name = "fileMode.append",
            __eq = function (self, other)
                return Type.from(self) == Type.from(other)
            end,
            __tostring = function() return "appendByte" end
        }
    ),
}, {
    __name = "fileMode",
    __newindex = function() error("FileMode is immutable", 2) end
})

--- FILE ---
fs.meta.File = {
    __name = "file",
    __newindex = function() error("File is immutable", 2) end
}
fs.File = {
    ---@param path Path|string
    ---@param fmode FileMode
    ---@return File|nil
    open = function(path, fmode)
        assertType(1, path, "path", "string")
        if type(path) == "string" then path = fs.Path.new(path) end
        assertType(2, fmode, "fileMode")
        local file = io.open(path.path, fmode.string) if not file then return nil end
        return setmetatable(
            ---@class File
            {
                __FILE = file,
                path = path, mode = fmode,
                ---@param self File
                close = function(self) return self.__FILE:close() end,
                ---@param self File
                flush = function(self) return self.__FILE:flush() end,
                ---@param self File
                lines = function(self) return self.__FILE:lines() end,
                ---@param self File
                ---@param ... string|integer|"*a"|"*l"|"*n"
                read = function(self, ...) return self.__FILE:read(...) end,
                ---@param self File
                readAll = function(self) return self.__FILE:read("*a") end,
                ---@param self File
                seek = function(self) return self.__FILE:seek() end,
                ---@param self File
                ---@param ... string|number
                write = function(self, ...) return self.__FILE:write(...) end,
                ---@param self File
                ---@param mode "full"|"line"|"no"
                ---@param size? integer
                setvbuf = function(self, mode, size) return self.__FILE:setvbuf(mode, size) end,
            },
            fs.meta.File
        )
    end,
}

return fs