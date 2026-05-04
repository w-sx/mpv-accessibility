-- module.events.lua

local msg = require 'driver.main'

mp.register_event("end-file", function()
    msg.freeze()
end)

-- Event: Seek (Reports current time and total duration)
mp.register_event("seek", function()
    msg.msg(mp.get_property_osd("time-pos"))
end)

mp.enable_messages("info")

mp.register_event("log-message", function(log)
    if log.text:lower():find("screenshot") then
        msg.msg(log.text)
    end
end)
