-- driver.main.lua

-- Driver list
local drivers_to_try = {
    "nvda",
    "title" -- to fallback
}

local driver = nil
local timer = nil
local msg = {}
local timeout = 0.2 -- 默认超时
local can_speak = true

local function load_driver()
    for _, name in ipairs(drivers_to_try) do
        -- Build path
        local path = "driver." .. name .. ".main"
        -- Use pcall to prevent crash if file is missing
        local success, drv = pcall(require, path)
        if success then
            -- Check if driver is available and running
            if drv and drv.is_running then
                --print("Driver loaded successfully: " .. name)
                driver = drv
                return true
            else
                print("Driver " .. name .. " found but not running (is_running is false)")
            end
        else
            print("Failed to load driver " .. name .. " (file may not exist)")
        end
    end
    return false
end

function msg.freeze(t)
    can_speak = false
    local t = t or timeout
        if timer then 
        timer:kill() 
        timer = nil
    end
    timer = mp.add_timeout(t, function()
        can_speak = true
        timer = nil
    end)
end

-- Message encapsulation
function msg.msg(text, interrupt,freeze)
    -- Return if in freeze period
    if not can_speak then return end
    -- Return if driver is unavailable
    if not driver then return end
    -- Return if screen reader is not running
    if not driver.is_running() then return end
    driver.speak(text, interrupt)
    --driver.braille(text)
    if freeze_time then msg.freeze(freeze_time) end
end

-- Set freeze state
function msg.set_freeze(state)
    can_speak = state
end

-- Initialization
if load_driver() then return msg
else return nil end