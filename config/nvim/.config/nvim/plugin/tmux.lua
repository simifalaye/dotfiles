-- Only load if inside tmux
if not vim.env.TMUX and vim.g.loaded_user_plugin_tmux then
  return
end
vim.g.loaded_user_plugin_tmux = true

---@alias nvim_direction_t 'h'|'j'|'k'|'l'
---@alias tmux_direction_t 'L'|'D'|'U'|'R'
---@alias tmux_borderpane_direction_t 'left'|'bottom'|'top'|'right'

---@return string tmux socket path
local function tmux_get_socket()
  return vim.split(vim.env.TMUX, ",")[1]
end

---@param command string tmux command to execute
---@param global boolean? command should be executed globally instead of in current pane
---@return string tmux command output
local function tmux_exec(command, global)
  command = global and string.format("tmux %s", command)
    or string.format("tmux -S %s %s", tmux_get_socket(), command)
  local handle = assert(
    io.popen(command),
    string.format("[tmux-nav]: unable to execute: [%s]", command)
  )
  local result = handle:read("*a")
  handle:close()
  return result
end

---@param command string tmux command to execute
---@param global boolean? command should be executed globally instead of in current pane
---@return function: rhs of a command keymap
local function tmux_exec_wrap(command, global)
  return function()
    tmux_exec(command, global)
  end
end

---Get tmux option value in current pane
---@param opt string tmux pane option
---@return string tmux pane option value
local function tmux_get_pane_opt(opt)
  return (
    tmux_exec(
      string.format(
        "display-message -pt %s '#{%s}'",
        vim.env.TMUX_PANE,
        vim.fn.escape(opt, "'\\")
      )
    ):gsub("\n.*", "")
  )
end

---Set tmux option value in current pane
---@param opt string tmux pane option
---@param val string tmux pane option value
---@return nil
local function tmux_set_pane_opt(opt, val)
  tmux_exec(
    string.format("set -pt %s %s '%s'", vim.env.TMUX_PANE, opt, vim.fn.escape(val, "'\\"))
  )
end

---Unset a tmux pane option
---@param opt string tmux pane option
---@return nil
local function tmux_unset_pane_opt(opt)
  tmux_exec(
    string.format("set -put %s '%s'", vim.env.TMUX_PANE, vim.fn.escape(opt, "'\\"))
  )
end

---@return boolean
local function tmux_is_zoomed()
  return tmux_get_pane_opt("window_zoomed_flag") == "1"
end

---@type table<nvim_direction_t, tmux_borderpane_direction_t>
local tmux_pane_position_map = {
  h = "left",
  j = "bottom",
  k = "top",
  l = "right",
}

---@param direction nvim_direction_t
---@return boolean
local function tmux_at_border(direction)
  return tmux_get_pane_opt("pane_at_" .. tmux_pane_position_map[direction]) == "1"
end

---@type table<nvim_direction_t, tmux_direction_t>
local tmux_direction_map = {
  h = "L",
  j = "D",
  k = "U",
  l = "R",
}

---@param direction nvim_direction_t
---@param count integer? default to 1
---@param zoomed boolean?
---@return nil
local function tmux_navigate(direction, count, zoomed)
  count = count or 1
  local cmd = string.format(
    "select-pane -t '%s' -%s",
    vim.env.TMUX_PANE,
    tmux_direction_map[direction]
  )
  if zoomed then
    cmd = "select-pane -t :.+ -Z"
  end
  for _ = 1, count do
    tmux_exec(cmd)
  end
end

---@param direction nvim_direction_t
---@return boolean
local function nvim_at_border(direction)
  return vim.fn.winnr() == vim.fn.winnr(direction)
end

---@return boolean
local function nvim_in_floating_win()
  return vim.fn.win_gettype() == "popup"
end

---@param direction nvim_direction_t
---@param count integer? default to 1
---@return nil
local function nvim_navigate(direction, count)
  vim.cmd.wincmd({
    direction,
    count = count,
  })
end

---@param direction nvim_direction_t
---@param count integer? default to 1
---@return nil
local function navigate(direction, count)
  count = count or 1
  if nvim_at_border(direction) or nvim_in_floating_win() then
    local zoomed = tmux_is_zoomed()
    if not zoomed and tmux_at_border(direction) then
      return
    end
    tmux_navigate(direction, count, zoomed)
  else
    nvim_navigate(direction, count)
  end
end

---@param direction nvim_direction_t
---@return function: rhs of a window navigation keymap
local function navigate_wrap(direction)
  return function()
    navigate(direction, vim.v.count1)
  end
end

--------------------------------------------------------------------------------
--  Main
--------------------------------------------------------------------------------

local m = require("utils.map")

m.map({ "n", "x", "t" }, "<A-h>", navigate_wrap("h"), "Goto left window")
m.map({ "n", "x", "t" }, "<A-j>", navigate_wrap("j"), "Goto down window")
m.map({ "n", "x", "t" }, "<A-k>", navigate_wrap("k"), "Goto up window")
m.map({ "n", "x", "t" }, "<A-l>", navigate_wrap("l"), "Goto right window")
m.map(
  { "n", "x", "t" },
  "<A-C-h>",
  tmux_exec_wrap("resize-pane -L 4"),
  "Resize window left"
)
m.map(
  { "n", "x", "t" },
  "<A-C-j>",
  tmux_exec_wrap("resize-pane -D 4"),
  "Resize window down"
)
m.map(
  { "n", "x", "t" },
  "<A-C-k>",
  tmux_exec_wrap("resize-pane -U 4"),
  "Resize window up"
)
m.map(
  { "n", "x", "t" },
  "<A-C-l>",
  tmux_exec_wrap("resize-pane -R 4"),
  "Resize window right"
)
