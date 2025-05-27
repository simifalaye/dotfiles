local M = {
  "echasnovski/mini.bufremove",
  version = "*",
  config = true,
}

M.keys = {
  {
    "<leader>x",
    function()
      require("mini.bufremove").delete()
    end,
    desc = "Buffer Delete",
  },
  {
    "<leader>X",
    function()
      require("mini.bufremove").wipeout()
    end,
    desc = "Buffer Wipeout",
  },
}

return M
