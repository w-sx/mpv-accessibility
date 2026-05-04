-- driver.nvda.main.lua

local ffi = require("ffi")
local nvda = {}

-- Get absolute path of the DLL
local script_path = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
local dll_path = script_path .. "nvdaControllerClient.dll"

-- Define C interfaces
ffi.cdef[[
    typedef unsigned short wchar_t;
    int nvdaController_testIfRunning();
    int nvdaController_speakText(const wchar_t* text);
    int nvdaController_speakSsml(const wchar_t* ssml, int position, int flags, int sync);
    int nvdaController_brailleMessage(const wchar_t* text);
    int nvdaController_cancelSpeech();
    // SSML Callback definition
    typedef int (__stdcall *onMarkReached_callback)(const wchar_t* name);
    int nvdaController_setOnSsmlMarkReachedCallback(onMarkReached_callback callback);
    // Windows API for encoding conversion (UTF-8 to UTF-16)
    int MultiByteToWideChar(unsigned int CodePage, unsigned long dwFlags, const char* lpMultiByteStr, int cbMultiByte, wchar_t* lpWideCharStr, int cchWideChar);
]]

-- Safely load DLL
local status, nvda_dll = pcall(ffi.load, dll_path)
if not status then
    print("A11Y nvda_dll Error: Failed to load DLL -> " .. dll_path)
    -- Return nil to prevent crash
    return nil
end

-- UTF-8 to UTF-16 conversion
local function to_utf16(str)
    local CP_UTF8 = 65001
    local len = ffi.C.MultiByteToWideChar(CP_UTF8, 0, str, #str, nil, 0)
    local buf = ffi.new("wchar_t[?]", len + 1)
    ffi.C.MultiByteToWideChar(CP_UTF8, 0, str, #str, buf, len)
    buf[len] = 0
    return buf
end

-- Check if NVDA is running
function nvda.is_running()
    local res = nvda_dll.nvdaController_testIfRunning()
    if res == 0 then return true
    else return false end
end

-- Text to speech
function nvda.speak(text, interrupt)
    if interrupt then nvda_dll.nvdaController_cancelSpeech() end
    nvda_dll.nvdaController_speakText(to_utf16(text))
end

-- Braille output
function nvda.braille(text)
    --nvda_dll.nvdaController_brailleMessage(to_utf16(text))
end

return nvda