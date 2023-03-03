return {
  {
    "ojroques/nvim-osc52",
    keys = {
      { "gy", mode = { "n", "x" } },
    },
    config = function()
      local m = require("utils.map")
      m.nnoremap("gy", require("osc52").copy_operator, "System yank", { expr = true })
      m.nmap("gyy", "gy_", "System yank line")
      m.xmap("gy", require("osc52").copy_visual, "System yank visual")
    end,
  },
}
