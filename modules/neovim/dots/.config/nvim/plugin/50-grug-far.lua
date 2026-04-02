vim.schedule(function()
  vim.pack.add({
    {
      src = "https://github.com/MagicDuck/grug-far.nvim",
      version = vim.version.range("*"),
    },
  })

  require("grug-far").setup({
    windowCreationCommand = "botright split",
    showCompactInputs = true,
    openTargetWindow = {
      -- preferred location for target window relative to the grug-far window. If an existing candidate
      -- window that is not excluded by the exclude filter exists in that direction, it will be reused,
      -- otherwise a new window will be created in that direction.
      -- available options: "prev" | "left" | "right" | "above" | "below"
      preferredLocation = "prev",
    },
  })

  vim.keymap.set({ "n" }, "<leader>/", function()
    require("grug-far").open({ transient = true })
  end, { desc = "Search: replace in files using grug-far" })

  vim.keymap.set({ "x" }, "<leader>/", function()
    require("grug-far").open({
      visualSelectionUsage = "operate-within-range",
      transient = true,
    })
  end, { desc = "Search: inside current range using grug-far" })
end)
