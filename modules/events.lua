-- modules.events.lua

local msg = require 'driver.main'

mp.register_event("end-file", function()
    msg.freeze()
end)

-- Event: Seek (Reports current time and total duration)
mp.register_event("seek", function()
    msg.msg(mp.get_property_osd("time-pos"))
end)
