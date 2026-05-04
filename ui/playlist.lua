-- ui.playlist.lua

-- Import module
local msg = require 'driver.main'
local utils = require 'mp.utils'

-- State variables
local layer = {}
local list_active = false
local selected_index = 0

-- announce selection
local function announce()
    -- Get title or filename
    local playlist = mp.get_property_native("playlist")
    local item = playlist[selected_index + 1]
    local _, name = utils.split_path(item.filename)
    local title = item.title or name
    msg.msg(string.format("%d. %s (%s)", selected_index + 1, title, item.filename))
end

-- change selection
local function change(delta)
    local count = #mp.get_property_native("playlist")
    if count == 0 then return msg.msg("Playlist is empty") end
    -- Boundary check
    if selected_index + delta < 0 or selected_index + delta >= count then return end
    selected_index = selected_index + delta
    announce()
end

-- Select playlist item
local function accept_selection()
    local playlist = mp.get_property_native("playlist")
    local title = playlist[selected_index + 1].title or playlist[selected_index + 1].filename
    msg.msg("Selected " .. title)
    mp.set_property_number("playlist-pos", selected_index)
    -- Auto exit list mode after selection
    layer.toggle_accessible_list()
end

-- Toggle accessible list mode
function layer.toggle_accessible_list()
    if not list_active then
        local count = mp.get_property_number("playlist-count") or 0
        if count == 0 then return msg.msg("Playlist is empty") end
        list_active = true
        -- Initialize index to current playing position
        selected_index = mp.get_property_number("playlist-pos") or 0
        -- Dynamic key bindings
        mp.set_key_bindings({
            {"k", function() change(-1) end},
            {"j", function() change(1) end},
            {"h", accept_selection},
            {"f8", layer.toggle_accessible_list},
            {"ESC", layer.toggle_accessible_list}
        }, "accessible_list", "force")
        mp.enable_key_bindings("accessible_list")
        msg.msg(string.format("Playlist (%d / %d). Use j or k to move, h to select, Esc or F8 to exit", selected_index+1, count))
        mp.command("show-text ${playlist}")
    else
        list_active = false
        mp.disable_key_bindings("accessible_list")
        msg.msg("Playlist closed")
    end
end

-- Bind F8 trigger
mp.add_key_binding("f8", "toggle_accessible_playlist", layer.toggle_accessible_list)

return layer