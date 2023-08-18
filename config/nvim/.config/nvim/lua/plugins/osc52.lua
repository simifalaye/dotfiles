return {
  {
    "ojroques/nvim-osc52",
    keys = {
      { "<leader>y", mode = { "n", "x" }, desc = "System yank" },
    },
    config = function()
      require("osc52").setup({
        silent = false,
      })
      local m = require("utils.map")
      local osc52 = require("osc52")
      m.nnoremap("<leader>y", osc52.copy_operator, "System yank", { expr = true })
      m.nmap("<leader>yy", "<leader>y_", "System yank line")
      m.xmap("<leader>y", osc52.copy_visual, "System yank visual")
    end,
  },
}
