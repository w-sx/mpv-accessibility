-- main.lua

local path = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
package.path = path .. "?.lua;" .. package.path

local msg = require("driver.main")
if not msg then return end

local ui = require("ui.main")

mp.register_event("end-file", function()
    msg.freeze()
end)

-- Event: Seek (Reports current time and total duration)
mp.register_event("seek", function()
    msg.msg(mp.get_property_osd("time-pos"))
end)

mp.observe_property("pause", "bool", function(key, value)
    local status = value and "Paused" or "Playing"
    msg.msg(status)
end)

mp.observe_property("sub-text", "string", function(key, value)
    if value and mp.get_property_bool("sub-visibility") then msg.msg(value,false) end
end)

-- Helper: Format values for speech
local function format_value(name, val)
    if type(val) == "boolean" then
        return val and "On" or "Off"
    end
    if type(val) == "number" then
        -- Handle units for specific properties
        if name == "sub-pos" then return math.floor(val) .. "%" end
        if name == "volume" then return math.floor(val) end
        if name == "speed" then return string.format("%.2f X", val) end
        if name == "sub-delay" then return string.format("%.2f s", val) end
        
        -- Generic numbers: Integer if whole, else 2 decimal places
        return (val % 1 == 0) and tostring(val) or string.format("%.2f", val)
    end
    return tostring(val)
end

-- Property mapping for observation
local target_properties = {
    ["fullscreen"]      = "Fullscreen",
    ["ontop"]           = "On top",
    ["loop-file"]       = "Loop",
    ["shuffle"]         = "Shuffle",
    ["video-zoom"]      = "Zoom",
    ["chapter-metadata/title"] = "Chapter:",
    ["sub-visibility"]  = "Subtitle",
    ["sid"]             = "Subtitle track",
    ["sub-pos"]         = "Subtitle position",
    ["sub-delay"]       = "Subtitle delay",
    ["sub-ass-override"] = "ASS style override",
    ["panscan"]         = "Panscan",
    ["deinterlace"]     = "Deinterlace",
    ["speed"]           = "Speed",
--  ["volume"]          = "Volume",
    ["mute"]            = "Mute",
    ["deband"]          = "Deband"
}

-- Batch register observers
for prop_name, display_name in pairs(target_properties) do
    mp.observe_property(prop_name, "native", function(name, val)
        if val == nil then return end

        local status_text = format_value(name, val)
        local final_msg = string.format("%s %s", display_name, status_text)
        
        msg.msg(final_msg)
    end)
end

mp.observe_property("playlist-pos", "number", function(_, val)
    if val == nil then return end
    local count = mp.get_property_number("playlist-count", 0)
    msg.msg(string.format("%d of %d", val + 1, count))
end)

    msg.freeze()
    mp.set_property("title", "${media-title} - mpv(Accessibility)")