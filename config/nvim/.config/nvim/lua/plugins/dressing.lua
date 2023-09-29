return {
  {
    "stevearc/dressing.nvim",
    init = function()
      require("utils").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" })
    end,
    opts = {},
  },
}
