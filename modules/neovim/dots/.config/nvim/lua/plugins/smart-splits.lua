local M = {
  "mrjones2014/smart-splits.nvim",
  version = "*",
}

M.event = { "WinEnter" }

M.keys = {
  {
    "<A-h>",
    function()
      require("smart-splits").resize_left()
    end,
    desc = "Resize window left",
  },
  {
    "<A-j>",
    function()
      require("smart-splits").resize_down()
    end,
    desc = "Resize window down",
  },
  {
    "<A-k>",
    function()
      require("smart-splits").resize_up()
    end,
    desc = "Resize window up",
  },
  {
    "<A-l>",
    function()
      require("smart-splits").resize_right()
    end,
    desc = "Resize window right",
  },
  {
    "<C-h>",
    function()
      require("smart-splits").move_cursor_left()
    end,
    desc = "Move to window left",
  },
  {
    "<C-j>",
    function()
      require("smart-splits").move_cursor_down()
    end,
    desc = "Move to window down",
  },
  {
    "<C-k>",
    function()
      require("smart-splits").move_cursor_up()
    end,
    desc = "Move to window down",
  },
  {
    "<C-l>",
    function()
      require("smart-splits").move_cursor_right()
    end,
    desc = "Move to window right",
  },
  {
    "<C-\\>",
    function()
      require("smart-splits").move_cursor_previous()
    end,
    desc = "Move to window prev",
  },
}

M.opts = {}

return M
