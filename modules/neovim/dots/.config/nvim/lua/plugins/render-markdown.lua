local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  version = "*",
}

M.dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" } -- if you use standalone mini plugin

M.ft = { "markdown" }

---@module 'render-markdown'
---@type render.md.UserConfig
M.opts = {}

return M
