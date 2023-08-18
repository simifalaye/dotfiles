return {
  {
    "google/executor.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>er", ":ExecutorRun<CR>", desc = "Run" },
      { "<leader>es", ":ExecutorShowPresets<CR>", desc = "Select Run" },
      { "<leader>ev", ":ExecutorToggleDetail<CR>", desc = "View Output" },
    },
    opts = {
      use_split = true,
      split = {
        -- One of "top", "right", "bottom" or "left"
        position = "bottom",
        -- The number of columns to take up. This sets the split to 1/4 of the
        -- space. If you're using the split at the top or bottom, you could also
        -- use `vim.o.lines` to set this relative to the height of the window.
        size = math.floor(vim.o.lines * 1 / 2),
      },
      preset_commands = {
        ["/"] = {
          "make build",
          "make test",
          "make clean && make docker",
          "make clean",
        },
      },
    },
    init = function()
      require("utils.map").group("<leader>e", "+executor")
    end,
  },
}
