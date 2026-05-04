-- ui.main.lua

local ui = {}

ui.playlist = require("ui.playlist")

local msg = require 'driver.main'

function ui.report_progress()
    local time_pos = mp.get_property_osd("time-pos")
    local duration = mp.get_property_osd("duration")
    local percent = mp.get_property_number("percent-pos", 0)    
    local text = string.format("%s / %s (%d%%)", time_pos, duration, math.floor(percent))
    
    -- Send message to driver
    msg.msg(text)
    mp.command("show-progress")
end

-- Bind key o
mp.add_key_binding("o", "report_progress", ui.report_progress)

return ui