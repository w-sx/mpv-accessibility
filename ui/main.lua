-- ui.main.lua

local msg = require 'driver.main'

local ui = {}

ui.shortcuts = require("ui.shortcuts")
ui.playlist = require("ui.playlist")
ui.keylist = require("ui.keylist")

msg.freeze()
mp.set_property("title", "${media-title} - mpv(Accessibility)")

return ui