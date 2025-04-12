local M = {
  "j-hui/fidget.nvim",
  lazy = false,
  keys = {
    {
      "g{",
      "<cmd>Fidget history<CR>",
      desc = "Show notification history",
    },
    {
      "g}",
      "<cmd>Fidget clear<CR>",
      desc = "Clear notifications",
    },
  },
  opts = {
    notification = {
      override_vim_notify = true,
      filter = vim.g.user_log_level or vim.log.levels.INFO,
    },
  },
}

M.config = function(_, opts)
  require("fidget").setup(opts)

  local telescope_ok, telescope = pcall(require, "telescope")
  if telescope_ok then
    telescope.load_extension("fidget")
    vim.keymap.set(
      "n",
      "g{",
      "<cmd>Telescope fidget<CR>",
      { desc = "Show notification history" }
    )
  end
end

return M
