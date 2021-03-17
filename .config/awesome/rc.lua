-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local menubar = require("menubar")

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")
modkey = RC.vars.modkey

-- Error handling
require("main.error-handling")

-- Variable definitions
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.wallpaper = RC.vars.wallpaper

-- -- --

-- Calling All Module Libraries

-- Custom Local Library
local main = {
  layouts = require("main.layouts"),
  tags    = require("main.tags"),
  menu    = require("main.menu"),
  rules   = require("main.rules"),
}

-- Custom Local Library: Keys and Mouse Binding
local binding = {
  globalbuttons = require("binding.globalbuttons"),
  clientbuttons = require("binding.clientbuttons"),
  globalkeys    = require("binding.globalkeys"),
  bindtotags    = require("binding.bindtotags"),
  clientkeys    = require("binding.clientkeys")
}

-- Layouts
RC.layouts = main.layouts()

-- Tags
RC.tags = main.tags()

-- Menu
local debian = require("debian.menu") -- Load Debian menu entries
local has_fdo, freedesktop = pcall(require, "freedesktop")
if has_fdo then
    RC.mainmenu = freedesktop.menu.build({
        before = { main.menu().awesome },
        after =  { main.menu().terminal }
    })
else
    RC.mainmenu = awful.menu({
        items = {
                  main.menu().awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  main.menu().terminal,
                }
    })
end
RC.launcher = awful.widget.launcher(
    { image = beautiful.awesome_icon, menu = RC.mainmenu }
)
menubar.utils.terminal = RC.vars.terminal

-- Mouse and Key bindings
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Statusbar: Wibar
require("deco.statusbar")

-- Rules
awful.rules.rules = main.rules(
  binding.clientkeys(),
  binding.clientbuttons()
)

-- Signals
require("main.signals")

-- Autostart Apps
awful.spawn.with_shell("compton --config ~/.config/compton/compton.conf") -- compositor
awful.spawn.with_shell("nitrogen --restore") -- wallpaper
