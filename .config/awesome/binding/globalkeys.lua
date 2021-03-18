-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local _M = {}
local modkey = RC.vars.modkey
local volumectl = RC.vars.volumectl

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalkeys = gears.table.join(
    -- Awesome keybinds
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group = "awesome"}),
    awful.key({ modkey,           }, "w", function ()
      RC.mainmenu:toggle()
    end,
    {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey }, "x", function ()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey }, "Escape", RC.vars.lockscreen,
    {description = "Lock screen", group = "awesome"}),

    -- Launcher keybinds
    awful.key({ modkey,           }, "Return", function ()
      awful.spawn(RC.vars.terminal)
    end,
    {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function ()
      awful.screen.focused().mypromptbox:run()
    end,
    {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "space", function()
      menubar.show()
    end,
    {description = "show the menubar", group = "launcher"}),

    -- Layout keybinds
    awful.key({ modkey, "Control" }, "l",     function ()
      awful.tag.incmwfact( 0.05)
    end,
    {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function ()
      awful.tag.incmwfact(-0.05)
    end,
    {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey,           }, "i",     function ()
      awful.tag.incnmaster( 1, nil, true)
    end,
    {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey,           }, "d",     function ()
      awful.tag.incnmaster(-1, nil, true)
    end,
    {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey,           }, "y", function ()
      awful.layout.inc( 1)
    end,
    {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "y", function ()
      awful.layout.inc(-1)
    end,
    {description = "select previous", group = "layout"}),
    awful.key({ modkey,           }, "t", function ()
      awful.layout.set(awful.layout.suit.tile)
    end,
    {description = "select tiled layout", group = "layout"}),
    awful.key({ modkey,           }, "m", function ()
      awful.layout.set(awful.layout.suit.max)
    end,
    {description = "select maximized layout", group = "layout"}),
    awful.key({ modkey,           }, "f", function ()
      awful.layout.set(awful.layout.suit.max.fullscreen)
    end,
    {description = "select fullscreen layout", group = "layout"}),

    -- Screen keybinds
    awful.key({ modkey, "Control" }, "k", function ()
      awful.screen.focus_relative( 1)
    end,
    {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "j", function ()
      awful.screen.focus_relative(-1)
    end,
    {description = "focus the previous screen", group = "screen"}),

    -- Tag keybinds
    awful.key({ modkey,           }, "p",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "n",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

    -- Media keys
    awful.key({ }, "XF86AudioMute", function ()
      awful.spawn(volumectl .. " mute")
    end),
    awful.key({ }, "XF86AudioRaiseVolume", function ()
      awful.spawn(volumectl .. " inc")
    end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
      awful.spawn(volumectl .. " dec")
    end),
    awful.key({ }, "XF86MonBrightnessDown", function ()
      awful.spawn("xbacklight -dec 10")
    end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
      awful.spawn("xbacklight -inc 10")
    end)
  )

  return globalkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
