-- main.lua

local path = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
package.path = path .. "?.lua;" .. package.path

local msg = require("driver.main")
if not msg then return end

local ui = require("ui.main")
local module = require("module.main")
