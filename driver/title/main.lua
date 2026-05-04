-- driver.title.main.lua
local title = {}

-- Store original title to restore it later if needed
local original_title = mp.get_property("title")
local timer = nil
title.timeout = 3

-- Always returns true as it's a software fallback
function title.is_running()
    return true
end

-- Update title with feedback text
function title.speak(text, interrupt)
    if not text or text == "" then return end
    -- Stop existing timer if it's still running
    if timer then
        timer:kill()
        timer = nil
    else
        -- Store original title
        original_title = mp.get_property("title")
    end
    mp.set_property("title", text)
    -- Restore title after title.timeout of inactivity
    timer = mp.add_timeout(title.timeout, function()
        mp.set_property("title", original_title)
        timer = nil
    end)
end

return title