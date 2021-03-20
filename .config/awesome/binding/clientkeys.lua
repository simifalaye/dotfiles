-- Standard Awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientkeys = gears.table.join(
    -- Moving window focus works between desktops
    awful.key({ modkey }, "k", function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}),
    awful.key({ modkey }, "j", function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus prev by index", group = "client"}),

    -- Moving windows between positions works between desktops
    awful.key({ modkey, "Shift" }, "k", function ()
      awful.client.swap.byidx(  1)
    end,
    {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function ()
      awful.client.swap.byidx( -1)
    end,
    {description = "swap with prev client by index", group = "client"}),

    -- General
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey }, "Tab", function ()
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
    awful.key({ modkey, "Shift" }, "o", function (c)
      c:move_to_screen()
    end,
    {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Shift" }, "c",
      function (c)
        c:kill()
      end,
    {description = "close", group = "client"})
  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
