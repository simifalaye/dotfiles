return {
  "echasnovski/mini.bufremove",
  version = "*",
  keys = {
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
  },
  config = true,
}
