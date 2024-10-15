require("fidget").setup({
  notification = {
    override_vim_notify = true,
    filter = vim.g.user_log_level,
  },
})

vim.keymap.set(
  "n",
  "g{",
  "<cmd>Fidget history<CR>",
  { desc = "Show notification history" }
)
vim.keymap.set(
  "n",
  "g}",
  "<cmd>Fidget clear_history<CR>",
  { desc = "Clear notification history" }
)
vim.keymap.set(
  "n",
  "g\\",
  "<cmd>Fidget clear<CR>",
  { desc = "Clear active notifications" }
)
