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

-- Property mapping for observation
local target_properties = {
    ["fullscreen"] = "Fullscreen",
    ["ontop"] = "On top",
    ["loop-file"] = "Loop",
    ["shuffle"] = "Shuffle",
    ["video-zoom"] = "Zoom",
    ["chapter-metadata/title"] = "Chapter",
    ["sub-visibility"] = "Subtitles",
    ["sid"] = "Subtitle track",
    ["sub-pos"] = "Sub position",
    ["sub-delay"] = "Sub delay",
    ["sub-ass-override"] = "ASS subtitle style override",
    ["panscan"] = "Panscan",
    ["deinterlace"] = "Deinterlace",
    ["speed"] = "Speed",
  ["volume"] = "Volume",
    ["mute"] = "Mute",
    ["deband"] = "Deband",
    ["ab-loop-a"] = "A-B loop start",
    ["ab-loop-b"] = "A-B loop end"
}

-- Batch register observers
for prop_name, display_name in pairs(target_properties) do
    mp.observe_property(prop_name, "native", function(name, val)
        if val == nil then return end
        msg.msg(display_name .. ": " .. mp.get_property_osd(name))
    end)
end

    msg.freeze()
    mp.set_property("title", "${media-title} - mpv(Accessibility)")