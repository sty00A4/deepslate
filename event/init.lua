local event = {
    meta = {}
}

event.meta.Event = {
    __eq = function (self, other)
        if type(self) == type(other) then
            for k, v in pairs(self) do
                if other[k] ~= v then
                    return false
                end
            end
            return true
        end
        return false
    end
}

event.Event = {
    ---@param id integer
    ---@return event.alarm
    alarm = function(id)
        assertType(1, id, "number")
        return setmetatable(
            ---@class event.alarm
            { code = id, eq = event.meta.Event.__eq },
            { __name = "event.alarm" }
        )
    end,
    ---@param char string
    ---@return event.char
    char = function(char)
        assertType(1, char, "string")
        assertValue("#char", #char, 1)
        return setmetatable(
            ---@class event.char
            { char = char, eq = event.meta.Event.__eq },
            { __name = "event.char" }
        )
    end,
    ---@param args string
    ---@return event.computer_command
    computer_command = function(args)
        assertType(1, args, "string")
        return setmetatable(
            ---@class event.computer_command
            { args = args, eq = event.meta.Event.__eq },
            { __name = "event.computer_command" }
        )
    end,
    ---@param side "left"|"right"|"top"|"bottom"|"back"
    ---@return event.disk
    disk = function(side)
        assertType(1, side, "string")
        assertValue(1, side, "left", "right", "top", "bottom", "back")
        return setmetatable(
            ---@class event.disk
            { side = side, eq = event.meta.Event.__eq },
            { __name = "event.disk" }
        )
    end,
    ---@param side "left"|"right"|"top"|"bottom"|"back"
    ---@return event.disk_eject
    disk_eject = function(side)
        assertType(1, side, "string")
        assertValue(1, side, "left", "right", "top", "bottom", "back")
        return setmetatable(
            ---@class event.disk_eject
            { side = side, eq = event.meta.Event.__eq },
            { __name = "event.disk_eject" }
        )
    end,
    ---@param files table
    ---@return event.file_transfer
    file_transfer = function(files)
        return setmetatable(
            ---@class event.file_transfer
            { files = files, eq = event.meta.Event.__eq },
            { __name = "event.file_transfer" }
        )
    end,
    ---@param url string
    ---@param success boolean
    ---@param fail string|nil
    ---@return event.http_check
    http_check = function(url, success, fail)
        assertType(1, url, "string")
        assertType(2, success, "boolean")
        assertType(3, fail, "string", "nil")
        return setmetatable(
            ---@class event.http_check
            { url = url, success = success, fail = fail, eq = event.meta.Event.__eq },
            { __name = "event.http_check" }
        )
    end,
    ---@param url string
    ---@param err boolean
    ---@param handle table|nil
    ---@return event.http_failure
    http_failure = function(url, err, handle)
        assertType(1, url, "string")
        assertType(2, err, "boolean")
        return setmetatable(
            ---@class event.http_failure
            { url = url, err = err, handle = handle, eq = event.meta.Event.__eq },
            { __name = "event.http_failure" }
        )
    end,
    ---@param url string
    ---@param response table
    ---@return event.http_failure
    http_success = function(url, response)
        assertType(1, url, "string")
        return setmetatable(
            ---@class event.http_failure
            { url = url, response = response, eq = event.meta.Event.__eq },
            { __name = "event.http_success" }
        )
    end,
    ---@param code integer
    ---@param hold boolean
    ---@return event.key
    key = function(code, hold)
        assertType(1, code, "number")
        assertType(2, hold, "boolean")
        return setmetatable(
            ---@class event.key
            { code = code, hold = hold, eq = event.meta.Event.__eq },
            { __name = "event.key" }
        )
    end,
    ---@param code integer
    ---@return event.key_up
    key_up = function(code)
        assertType(1, code, "number")
        return setmetatable(
            ---@class event.key_up
            { code = code, eq = event.meta.Event.__eq },
            { __name = "event.key_up" }
        )
    end,
    ---@param side "left"|"right"|"top"|"bottom"|"back"
    ---@param channel integer
    ---@param response_channel integer
    ---@param message any
    ---@param distance number|nil
    ---@return event.modem_message
    modem_message = function(side, channel, response_channel, message, distance)
        assertType(1, side, "string")
        assertValue(1, side, "left", "right", "top", "bottom", "back")
        assertType(2, channel, "number")
        assertType(3, response_channel, "number")
        assertType(5, distance, "number", "nil")
        return setmetatable(
            ---@class event.modem_message
            {
                side = side, channel = channel, response_channel = response_channel,
                message = message, distance = distance,
                eq = event.meta.Event.__eq
            },
            { __name = "event.modem_message" }
        )
    end,
    ---@param id integer
    ---@return event.monitor_resize
    monitor_resize = function(id)
        assertType(1, id, "number")
        return setmetatable(
            ---@class event.monitor_resize
            { id = id, eq = event.meta.Event.__eq },
            { __name = "event.monitor_resize" }
        )
    end,
    ---@param id integer
    ---@param x integer
    ---@param y integer
    ---@return event.monitor_touch
    monitor_touch = function(id, x, y)
        assertType(1, id, "number")
        assertType(2, x, "number")
        assertType(3, y, "number")
        return setmetatable(
            ---@class event.monitor_touch
            { id = id, x = x, y = y, eq = event.meta.Event.__eq },
            { __name = "event.monitor_touch" }
        )
    end,
    ---@param button integer
    ---@param x integer
    ---@param y integer
    ---@return event.mouse_click
    mouse_click = function(button, x, y)
        assertType(1, button, "number")
        assertType(2, x, "number")
        assertType(3, y, "number")
        return setmetatable(
            ---@class event.mouse_click
            { button = button, x = x, y = y, eq = event.meta.Event.__eq },
            { __name = "event.mouse_click" }
        )
    end,
    ---@param button integer
    ---@param x integer
    ---@param y integer
    ---@return event.mouse_drag
    mouse_drag = function(button, x, y)
        assertType(1, button, "number")
        assertType(2, x, "number")
        assertType(3, y, "number")
        return setmetatable(
            ---@class event.mouse_drag
            { button = button, x = x, y = y, eq = event.meta.Event.__eq },
            { __name = "event.mouse_drag" }
        )
    end,
    ---@param dir integer
    ---@param x integer
    ---@param y integer
    ---@return event.mouse_scroll
    mouse_scroll = function(dir, x, y)
        assertType(1, dir, "number")
        assertValue(1, dir, -1, 1)
        assertType(2, x, "number")
        assertType(3, y, "number")
        return setmetatable(
            ---@class event.mouse_scroll
            { button = dir, x = x, y = y, eq = event.meta.Event.__eq },
            { __name = "event.mouse_scroll" }
        )
    end,
    ---@param button integer
    ---@param x integer
    ---@param y integer
    ---@return event.mouse_up
    mouse_up = function(button, x, y)
        assertType(1, button, "number")
        assertType(2, x, "number")
        assertType(3, y, "number")
        return setmetatable(
            ---@class event.mouse_up
            { button = button, x = x, y = y, eq = event.meta.Event.__eq },
            { __name = "event.mouse_up" }
        )
    end,
    ---@param text string
    ---@return event.paste
    paste = function(text)
        assertType(1, text, "string")
        return setmetatable(
            ---@class event.paste
            { text = text, eq = event.meta.Event.__eq },
            { __name = "event.paste" }
        )
    end,
    ---@param side "left"|"right"|"top"|"bottom"|"back"
    ---@return event.peripheral
    peripheral = function(side)
        assertType(1, side, "string")
        assertValue(1, side, "left", "right", "top", "bottom", "back")
        return setmetatable(
            ---@class event.peripheral
            { side = side, eq = event.meta.Event.__eq },
            { __name = "event.peripheral" }
        )
    end,
    ---@param side "left"|"right"|"top"|"bottom"|"back"
    ---@return event.peripheral_detach
    peripheral_detach = function(side)
        assertType(1, side, "string")
        assertValue(1, side, "left", "right", "top", "bottom", "back")
        return setmetatable(
            ---@class event.peripheral_detach
            { side = side, eq = event.meta.Event.__eq },
            { __name = "event.peripheral_detach" }
        )
    end,
    ---@param sender integer
    ---@param message any
    ---@param protocol string|nil
    ---@return event.rednet_message
    rednet_message = function(sender, message, protocol)
        assertType(1, sender, "number")
        assertType(3, protocol, "string", "nil")
        return setmetatable(
            ---@class event.rednet_message
            { sender = sender, message = message, protocol = protocol, eq = event.meta.Event.__eq },
            { __name = "event.rednet_message" }
        )
    end,
    ---@return event.redstone
    redstone = function()
        return setmetatable(
            ---@class event.redstone
            { eq = event.meta.Event.__eq },
            { __name = "event.redstone" }
        )
    end,
    ---@param speaker string|nil
    ---@return event.speaker_audio_empty
    speaker_audio_empty = function(speaker)
        assertType(1, speaker, "string")
        return setmetatable(
            ---@class event.speaker_audio_empty
            { speaker = speaker, eq = event.meta.Event.__eq },
            { __name = "event.speaker_audio_empty" }
        )
    end,
    ---@param id integer
    ---@param success boolean
    ---@param ... any
    ---@return event.task_complete
    task_complete = function(id, success, ...)
        assertType(1, id, "number")
        assertType(2, success, "boolean")
        if success then
            return setmetatable(
                ---@class event.task_complete
                { id = id, success = success, values = {...}, eq = event.meta.Event.__eq },
                { __name = "event.task_complete" }
            )
        else
            assertType(3, ({...})[1], "string")
            return setmetatable(
                ---@class event.task_complete
                { id = id, success = success, err = ({...})[1], eq = event.meta.Event.__eq },
                { __name = "event.task_complete" }
            )
        end
    end,
    ---@return event.term_resize
    term_resize = function()
        return setmetatable(
            ---@class event.term_resize
            { eq = event.meta.Event.__eq },
            { __name = "event.term_resize" }
        )
    end,
    ---@return event.terminate
    terminate = function()
        return setmetatable(
            ---@class event.terminate
            { eq = event.meta.Event.__eq },
            { __name = "event.terminate" }
        )
    end,
    ---@param id integer
    ---@return event.timer
    timer = function(id)
        assertType(1, id, "number")
        return setmetatable(
            ---@class event.timer
            { id = id, eq = event.meta.Event.__eq },
            { __name = "event.timer" }
        )
    end,
    ---@return event.turtle_inventory
    turtle_inventory = function()
        return setmetatable(
            ---@class event.turtle_inventory
            { eq = event.meta.Event.__eq },
            { __name = "event.turtle_inventory" }
        )
    end,
    ---@param url string
    ---@return event.websocket_closed
    websocket_closed = function(url)
        assertType(1, url, "string")
        return setmetatable(
            ---@class event.websocket_closed
            { url = url, eq = event.meta.Event.__eq },
            { __name = "event.websocket_closed" }
        )
    end,
    ---@param url string
    ---@param err string
    ---@return event.websocket_failure
    websocket_failure = function(url, err)
        assertType(1, url, "string")
        assertType(2, err, "string")
        return setmetatable(
            ---@class event.websocket_failure
            { url = url, err = err, eq = event.meta.Event.__eq },
            { __name = "event.websocket_failure" }
        )
    end,
    ---@param url string
    ---@param message string
    ---@param binary boolean
    ---@return event.websocket_message
    websocket_message = function(url, message, binary)
        assertType(1, url, "string")
        assertType(2, message, "string")
        assertType(3, binary, "binary")
        return setmetatable(
            ---@class event.websocket_message
            { url = url, message = message, binary = binary, eq = event.meta.Event.__eq },
            { __name = "event.websocket_message" }
        )
    end,
    ---@param url string
    ---@return event.websocket_success
    websocket_success = function(url, handle)
        assertType(1, url, "string")
        return setmetatable(
            ---@class event.websocket_success
            { url = url, handle = handle, eq = event.meta.Event.__eq },
            { __name = "event.websocket_success" }
        )
    end,
}

return event