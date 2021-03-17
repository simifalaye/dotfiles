-- Standard Awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientkeys = gears.table.join(
    -- Moving window focus works between desktops
    awful.key({ modkey,           }, "j", function (c)
      awful.client.focus.global_bydirection("down")
      c:lower()
    end,
    {description = "focus next window up", group = "client"}),
    awful.key({ modkey,           }, "k", function (c)
      awful.client.focus.global_bydirection("up")
      c:lower()
    end,
    {description = "focus next window down", group = "client"}),
    awful.key({ modkey,           }, "l", function (c)
      awful.client.focus.global_bydirection("right")
      c:lower()
    end,
    {description = "focus next window right", group = "client"}),
    awful.key({ modkey,           }, "h", function (c)
      awful.client.focus.global_bydirection("left")
      c:lower()
    end,
    {description = "focus next window left", group = "client"}),

    -- Moving windows between positions works between desktops
    awful.key({ modkey, "Shift"   }, "h", function (c)
      awful.client.swap.global_bydirection("left")
      c:raise()
    end,
    {description = "swap with left client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "l", function (c)
      awful.client.swap.global_bydirection("right")
      c:raise()
    end,
    {description = "swap with right client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function (c)
      awful.client.swap.global_bydirection("down")
      c:raise()
    end,
    {description = "swap with down client", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function (c)
      awful.client.swap.global_bydirection("up")
      c:raise()
    end,
    {description = "swap with up client", group = "client"}),

    -- General
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab", function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),
    awful.key({ modkey, "Shift" }, "Return", function (c)
      c:swap(awful.client.getmaster())
    end,
    {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "q", function (c) c:kill()
    end,
    {description = "close", group = "client"})
  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
