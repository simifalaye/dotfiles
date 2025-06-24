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
  {
    "<leader>un",
    function()
      if vim.g.mininotify_disable then
        vim.g.mininotify_disable = false
      else
        vim.g.mininotify_disable = true
      end

      local state = vim.g.mininotify_disable
      vim.notify(string.format("notifications %s", require("utils.ui").bool2str(not state)))
    end,
    desc = "Toggle notifications",
  },
}

M.config = function()
  local notify = require("mini.notify")
  notify.setup({})
  vim.notify = notify.make_notify()
end

return M
