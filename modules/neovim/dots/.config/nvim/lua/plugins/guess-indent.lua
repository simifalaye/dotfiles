local M = {
  "NMAC427/guess-indent.nvim",
}

M.event = { "BufReadPre" }

M.opts = {
  auto_cmd = true,
  override_editorconfig = false,
}

return M
