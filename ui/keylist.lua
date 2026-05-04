-- ui.keylist.lua

-- Import module
local msg = require 'driver.main'
local utils = require 'mp.utils'

-- State variables
local layer = {}
local list_active = false
local key_list = {}
local selected_index = 0

-- Update and parse active key bindings
local function update_data()
    local json = mp.get_property_native("input-bindings")
    local active_map = {}
    for _, binding in ipairs(json) do
        if binding.key and binding.cmd then
            -- Filter out internal OSC noise
            local is_osc = binding.owner == "osc" or binding.cmd:find("osc/")
            if not is_osc then
                -- Shadowing logic: later bindings override earlier ones
                active_map[binding.key] = {
                    key = binding.key,
                    cmd = binding.cmd,
                    comment = binding.comment or "",
                    priority = (binding.owner ~= "builtin")
                }
            end
        end
    end
    -- Convert map to sorted list
    key_list = {}
    for _, item in pairs(active_map) do
        if item.priority then
            table.insert(key_list, 1, item) -- User/Script keys first
        else
            table.insert(key_list, item)    -- Builtin keys last
        end
    end
end

-- Announce current key
local function announce()
    if #key_list == 0 then return msg.msg("Key list is empty") end
    local item = key_list[selected_index + 1]
    local description = (item.comment ~= "") and item.comment or item.cmd
    -- Format: Index. Key -> Description (Total)
    msg.msg(string.format("%s: %s (%d of %d)", 
        item.key, description, selected_index + 1, #key_list))
end

-- Change selection
local function change(delta)
    local count = #key_list
    if count == 0 then return end
    -- Boundary check
    if selected_index + delta < 0 or selected_index + delta >= count then return end
    selected_index = selected_index + delta
    announce()
end

-- Toggle accessible key list mode
function layer.toggle_accessible_list()
    if not list_active then
        update_data()
        local count = #key_list
        if count == 0 then return msg.msg("No active key bindings found") end
        
        list_active = true
        selected_index = 0
        
        -- Use same keymap style as playlist
        mp.set_key_bindings({
            {"k", function() change(-1) end},
            {"j", function() change(1) end},
            {"?", layer.toggle_accessible_list},
            {"ESC", layer.toggle_accessible_list}
        }, "accessible_keys", "force")
        mp.enable_key_bindings("accessible_keys")
        
        msg.msg(string.format("Key Bindings (%d items). Use j/k to move, Esc or ? to exit", count))
        announce()
    else
        list_active = false
        mp.disable_key_bindings("accessible_keys")
        msg.msg("Key list closed")
    end
end

-- Bind '?' trigger (matching mpv default help key)
mp.add_key_binding("?", "toggle_accessible_keylist", layer.toggle_accessible_list)

return layer