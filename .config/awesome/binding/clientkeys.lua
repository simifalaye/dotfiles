-- Standard Awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientkeys = gears.table.join(
    -- Focus on window
    awful.key({ modkey,           }, "h", function (c)
      awful.client.focus.bydirection("left")
      c:lower()
    end,
    {description = "focus left window", group = "client"}),
    awful.key({ modkey,           }, "j", function (c)
      awful.client.focus.bydirection("down")
      c:lower()
    end,
    {description = "focus down window", group = "client"}),
    awful.key({ modkey,           }, "k", function (c)
      awful.client.focus.bydirection("up")
      c:lower()
    end,
    {description = "focus up window", group = "client"}),
    awful.key({ modkey,           }, "l", function (c)
      awful.client.focus.bydirection("right")
      c:lower()
    end,
    {description = "focus right window", group = "client"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
      {description = "focus urgent window", group = "client"}),
    awful.key({ modkey }, "b", function (c)
      awful.client.focus.history.previous()
      if c.focus then
        c.focus:raise()
      end
    end,
    {description = "go back", group = "client"}),
    awful.key({ modkey, "Shift" }, "c",
      function (c)
        c:kill()
      end,
    {description = "close window", group = "client"}),

    -- Move windows
    awful.key({ modkey, "Shift"   }, "h", function (c)
      awful.client.swap.global_bydirection("left")
      c:raise()
    end,
    {description = "swap with left client", group = "client"}),
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
    awful.key({ modkey, "Shift"   }, "l", function (c)
      awful.client.swap.global_bydirection("right")
      c:raise()
    end,
    {description = "swap with right client", group = "client"}),
    awful.key({ modkey, "Shift" }, "o", function (c)
      c:move_to_screen()
    end,
    {description = "move to screen", group = "client"})
  )

  return clientkeys
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
