local reqcall = require("utils.reqcall")
local ss = reqcall("smart-splits") ---@module 'smart-splits'

return {
  {
    "mrjones2014/smart-splits.nvim",
    enabled = false,
    tag = "v1.2.4",
    keys = {
      { "<A-S-h>", ss.resize_left, desc = "Resize Window Left" },
      { "<A-S-j>", ss.resize_down, desc = "Resize Window Down" },
      { "<A-S-k>", ss.resize_up, desc = "Resize Window Up" },
      { "<A-S-l>", ss.resize_right, desc = "Resize Window Right" },
      { "<A-h>", ss.move_cursor_left, desc = "Goto Window Left" },
      { "<A-j>", ss.move_cursor_down, desc = "Goto Window Down" },
      { "<A-k>", ss.move_cursor_up, desc = "Goto Window Up" },
      { "<A-l>", ss.move_cursor_right, desc = "Goto Window Right" },
    },
    config = true,
  },
}
