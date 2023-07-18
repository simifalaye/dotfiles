--- Return a function that executes a smart-splits command lazy-loading it
--first if it is not loaded
---@param cmd string builtin command to run
---@vararg any? arguments to pass to the command
---@return fun()
local scmd = function(cmd, ...)
  local args = { ... }
  return function()
    require("smart-splits")[cmd](unpack(args))
  end
end

return {
  {
    "mrjones2014/smart-splits.nvim",
    tag = "v1.2.2",
    keys = {
      { "<A-h>", scmd("resize_left"), "Resize Window Left" },
      { "<A-j>", scmd("resize_down"), "Resize Window Down" },
      { "<A-k>", scmd("resize_up"), "Resize Window Up" },
      { "<A-l>", scmd("resize_right"), "Resize Window Right" },
      { "<C-h>", scmd("move_cursor_left"), "Goto Window Left" },
      { "<C-j>", scmd("move_cursor_down"), "Goto Window Down" },
      { "<C-k>", scmd("move_cursor_up"), "Goto Window Up" },
      { "<C-l>", scmd("move_cursor_right"), "Goto Window Right" },
    },
    config = true,
  },
}
