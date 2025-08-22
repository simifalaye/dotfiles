local wezterm = require("wezterm")

local function is_found(str, pattern)
  return string.find(str, pattern) ~= nil
end

-- Detect if running in WSL
local function has_wsl()
  local f = io.open("/proc/version", "r")
  if f then
    local version = f:read("*all")
    f:close()
    return version:match("Microsoft") ~= nil
  end
  return false
end

---@alias PlatformType 'windows' | 'linux' | 'mac'

---@return {os: PlatformType, is_win: boolean, is_linux: boolean, is_mac: boolean, is_wsl: boolean}
local function platform()
  local is_win = is_found(wezterm.target_triple, "windows")
  local is_linux = is_found(wezterm.target_triple, "linux")
  local is_mac = is_found(wezterm.target_triple, "apple")
  local is_wsl = false
  local os

  if is_win then
    os = "windows"
    is_wsl = has_wsl()
  elseif is_linux then
    os = "linux"
  elseif is_mac then
    os = "mac"
  else
    error("Unknown platform")
  end

  return {
    os = os,
    is_win = is_win,
    is_linux = is_linux,
    is_mac = is_mac,
    is_wsl = is_wsl,
  }
end

local _platform = platform()

return _platform
