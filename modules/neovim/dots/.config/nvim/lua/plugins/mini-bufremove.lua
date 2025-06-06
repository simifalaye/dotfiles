local M = {
  "echasnovski/mini.bufremove",
  version = "*",
}

M.keys = {
  {
    "<leader>bd",
    function()
      require("mini.bufremove").delete()
    end,
    desc = "Delete",
  },
  {
    "<leader>bw",
    function()
      require("mini.bufremove").wipeout()
    end,
    desc = "Wipeout",
  },
}

M.config = true

return M
