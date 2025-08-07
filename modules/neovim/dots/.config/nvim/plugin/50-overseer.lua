local deps = require("mini.deps")

deps.add({
  source = "stevearc/overseer.nvim",
})

deps.now(function()
  -- Load plugin
  require("overseer").setup({
    strategy = "jobstart",
  })

  -- Setup wk group
  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({ { "<leader>x", group = "+Execute" } })
  end

  -- Setup keymaps
  vim.keymap.set(
    "n",
    "<leader>xd",
    "<cmd>OverseerDeleteBundle<CR>",
    { desc = "Delete Bundle" }
  )
  vim.keymap.set(
    "n",
    "<leader>xl",
    "<cmd>OverseerLoadBundle<CR>",
    { desc = "Save Bundle" }
  )
  vim.keymap.set(
    "n",
    "<leader>xr",
    "<cmd>OverseerRun<CR>",
    { desc = "Execute task from template" }
  )
  vim.keymap.set(
    "n",
    "<leader>xR",
    "<cmd>OverseerRunCmd<CR>",
    { desc = "Execute shell cmd" }
  )
  vim.keymap.set(
    "n",
    "<leader>xs",
    "<cmd>OverseerSaveBundle<CR>",
    { desc = "Save Bundle" }
  )
  vim.keymap.set("n", "<leader>xx", "<cmd>OverseerToggle<CR>", { desc = "Toggle" })
end)
