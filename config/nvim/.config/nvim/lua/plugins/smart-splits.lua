local reqcall = require("utils.reqcall")
local ss = reqcall("smart-splits") ---@module 'smart-splits'

return {
  {
    "mrjones2014/smart-splits.nvim",
    tag = "v1.2.2",
    keys = {
      { "<A-h>", ss.resize_left, desc = "Resize Window Left" },
      { "<A-j>", ss.resize_down, desc = "Resize Window Down" },
      { "<A-k>", ss.resize_up, desc = "Resize Window Up" },
      { "<A-l>", ss.resize_right, desc = "Resize Window Right" },
      { "<C-h>", ss.move_cursor_left, desc = "Goto Window Left" },
      { "<C-j>", ss.move_cursor_down, desc = "Goto Window Down" },
      { "<C-k>", ss.move_cursor_up, desc = "Goto Window Up" },
      { "<C-l>", ss.move_cursor_right, desc = "Goto Window Right" },
    },
    config = true,
  },
}
