local M = {
  "echasnovski/mini.notify",
  version = "*",
}

M.lazy = false

M.keys = {
  {
    "g{",
    function()
      require("mini.notify").show_history()
    end,
    desc = "Show notification history",
  },
  {
    "g}",
    function()
      require("mini.notify").clear()
    end,
    desc = "Clear notifications",
  },
}

M.config = function()
  local notify = require("mini.notify")
  notify.setup({})
  vim.notify = notify.make_notify()
end

return M
