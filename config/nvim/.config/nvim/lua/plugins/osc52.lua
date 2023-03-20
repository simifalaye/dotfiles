return {
  {
    "ojroques/nvim-osc52",
    keys = {
      { "gy", mode = { "n", "x" } },
    },
    config = function()
      require("osc52").setup({
        silent = false
      })
      local m = require("utils.map")
      local osc52 = require("osc52")
      m.nnoremap("gy", osc52.copy_operator, "System yank", { expr = true })
      m.nmap("gyy", "gy_", "System yank line")
      m.xmap("gy", osc52.copy_visual, "System yank visual")
    end,
  },
}
