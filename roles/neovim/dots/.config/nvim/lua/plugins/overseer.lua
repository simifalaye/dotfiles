return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<CR>", desc = "Toggle" },
      { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run" },
    },
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({ ["<leader>o"] = { name = "+overseer" } })
      end
    end,
    opts = {},
  },
}
