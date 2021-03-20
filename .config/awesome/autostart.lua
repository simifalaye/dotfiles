local awful = require("awful")

local hostname = io.lines("/proc/sys/kernel/hostname")()
local layout_file = "~/.screenlayout/current.sh"
local autorun = {}

-- Applications to run for all host machines
autorun["all"] = {
  "compton --config ~/.config/compton/compton.conf",
  "nitrogen --restore",
  "redshift -l geoclue2"
}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Run a list of applications if they aren't already running
-- cmd_arr: Array of commands to run
local function run_once(cmd_arr)
  if cmd_arr ~= nil then
    for _, cmd in ipairs(cmd_arr) do
      local findme = cmd
      local firstspace = cmd:find(' ')
      if firstspace then findme = cmd:sub(0, firstspace - 1) end
      awful.spawn.with_shell(string.format(
          'pgrep -u $USER -x %s > /dev/null || (%s)',
        findme, cmd), false)
    end
  end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Execute display layout script
-- IMPORTANT: Must make any xrandr changes before starting compton
-- and compton must be stopped when making further changes later
local f=io.open(layout_file)
if f~=nil then
  io.close(f)
  awful.spawn.with_shell(layout_file)
end

run_once(autorun["all"])
run_once(autorun[hostname])
