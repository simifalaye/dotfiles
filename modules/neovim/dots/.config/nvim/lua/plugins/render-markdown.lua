local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  version = "*",
}

M.dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }

M.ft = { "markdown" }

---@module 'render-markdown'
---@type render.md.UserConfig
M.opts = {}

return M
