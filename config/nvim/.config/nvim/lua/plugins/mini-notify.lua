return {
  {
    "echasnovski/mini.notify",
    version = false,
    lazy = false,
    priority = 500,
    init = function()
      vim.notify = require("mini.notify").make_notify({
        ERROR = { duration = 5000, hl_group = "DiagnosticError" },
        WARN = { duration = 5000, hl_group = "DiagnosticWarn" },
        INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
        DEBUG = { duration = 10000, hl_group = "DiagnosticHint" },
        TRACE = { duration = 10000, hl_group = "DiagnosticOk" },
        OFF = { duration = 0, hl_group = "MiniNotifyNormal" },
      })
    end,
    keys = {
      { "<leader>n", "<leader>n", desc = "+noti" },
      { "<leader>nc", "<cmd>lua MiniNotify.clear()<CR>", desc = "Clear" },
      { "<leader>nn", "<cmd>lua MiniNotify.show_history()<CR>", desc = "Show" },
      { "<leader>nr", "<cmd>lua MiniNotify.refresh()<CR>", desc = "Refresh" },
    },
    opts = {
      lsp_progress = {
        enable = true,
      },
    },
  },
}
