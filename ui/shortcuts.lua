-- ui.shortcuts.lua

local msg = require 'driver.main'

local layer = {}

function layer.report_progress()
    local time_pos = mp.get_property_osd("time-pos", "unknown")
    local duration = mp.get_property_osd("duration", "unknown")
    local percent = mp.get_property_number("percent-pos", 0)
    local text = string.format("%s / %s (%d%%)", time_pos, duration, math.floor(percent))
    msg.msg(text)
    mp.command("show-progress")
end

-- Bind key
mp.add_key_binding("o", "report_progress", layer.report_progress)

return layer