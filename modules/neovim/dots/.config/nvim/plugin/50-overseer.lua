MiniDeps.add({
  source = "stevearc/overseer.nvim",
})

MiniDeps.now(function()
  local overseer = require("overseer")

  -- Load plugin
  overseer.setup({
    strategy = "jobstart",
  })

  -- Setup wk group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>x", group = "+Execute" } })
  end

  -- Keymaps
  vim.keymap.set("n", "<leader>xa", "<cmd>OverseerTaskAction<CR>", { desc = "Action" })
  vim.keymap.set("n", "<leader>xr", "<cmd>OverseerRun<CR>", { desc = "Run" })
  vim.keymap.set("n", "<leader>xx", "<cmd>OverseerToggle<CR>", { desc = "Toggle" })
end)
