-- module.properties.lua

local msg = require("driver.main")

-- Properties mapping for observation
local target_properties = {
    ["fullscreen"] = "Fullscreen",
    ["ontop"] = "On top",
    ["loop-file"] = "Loop",
    ["shuffle"] = "Shuffle",
    ["hwdec"] = "Hardware decoding",
    ["mute"] = "Mute",
    ["sub-visibility"] = "Subtitles",
    ["secondary-sub-visibility"] = "Secondary subtitles",
    ["deband"] = "Deband",
    ["deinterlace"] = "Deinterlace",
    ["sub-ass-override"] = "ASS subtitle style override",
    ["video-zoom"] = "Zoom",
    ["sub-pos"] = "Sub position",
    ["sub-delay"] = "Sub delay",
    ["panscan"] = "Panscan",
    ["speed"] = "Speed",
  ["volume"] = "Volume",
    ["sub-scale"] = "Sub scale",
    ["ab-loop-a"] = "A-B loop start",
    ["ab-loop-b"] = "A-B loop end",
    ["contrast"] = "Contrast",
    ["brightness"] = "Brightness",
    ["gamma"] = "Gamma",
    ["saturation"] = "Saturation",
    ["edition"] = "Edition",
    ["window-scale"] = "Window-scale",
    ["audio-delay"] = "Audio delay",
    ["video-pan-y"] = "Video-pan-y",
    ["video-pan-x"] = "Video-pan-x",
    ["video-aspect-override"] = "Aspect ratio override",
    ["sub-ass-use-video-data"] = "Subtitle using video properties",
    ["vid"] = "Video",
    ["aid"] = "audio",
    ["secondary-sid"] = "Secondary subtitle",
    ["sid"] = "Subtitle",
    ["chapter-metadata/title"] = "Chapter"
}

-- Announce properties change
for prop_name, display_name in pairs(target_properties) do
    mp.observe_property(prop_name, "native", function(name, val)
        if val == nil then return end
        msg.msg(display_name .. ": " .. mp.get_property_osd(name))
    end)
end

-- announce subtitles
mp.observe_property("sub-text", "string", function(key, value)
    if value and mp.get_property_bool("sub-visibility") then msg.msg(value,false) end
end)

-- Announce pause status
mp.observe_property("pause", "bool", function(key, value)
    msg.msg(value and "Paused" or "Playing")
end)
