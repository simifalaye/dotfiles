exec_later(function()
  vim.pack.add({
    {
      src = "https://github.com/brianhuster/live-preview.nvim",
    },
  })
  require("livepreview.config").set()
end)
