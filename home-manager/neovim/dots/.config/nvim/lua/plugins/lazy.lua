local M = {
  "folke/lazy.nvim",
  version = "*",
  lazy = false,
}

M.init = function()
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>p", group = "+plugin" } })
  end
  vim.keymap.set("n", "<leader>pp", "<cmd>Lazy home<CR>", { desc = "Open" })
  vim.keymap.set("n", "<leader>pc", "<cmd>Lazy clean<CR>", { desc = "Clean" })
  vim.keymap.set("n", "<leader>ph", "<cmd>Lazy health<CR>", { desc = "Health" })
  vim.keymap.set("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "Install" })
  vim.keymap.set("n", "<leader>ps", "<cmd>Lazy sync<CR>", { desc = "Sync" })
  vim.keymap.set("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "Update" })
end

return M
