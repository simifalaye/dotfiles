MiniDeps.now(function()
  MiniDeps.add({
    source = "j-hui/fidget.nvim",
  })

  -- Load plugin
  require("fidget").setup({
    notification = {
      override_vim_notify = true,
      filter = vim.g.user_log_level or vim.log.levels.INFO,
      view = { stack_upwards = false },
      window = {
        align = "top",
      },
    },
  })

  -- Setup keymaps
  vim.keymap.set(
    "n",
    "g{",
    "<cmd>Fidget history<CR>",
    { desc = "Show notification history" }
  )
  vim.keymap.set("n", "g}", "<cmd>Fidget clear<CR>", { desc = "Clear notifications" })

  -- Load telescope plugin if installed
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
end)
