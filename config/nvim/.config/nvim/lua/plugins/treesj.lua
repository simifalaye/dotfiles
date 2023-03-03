return {
  {
    "Wansmer/treesj",
    event = "BufEnter",
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
    keys = {
      { "<leader>t", "<cmd>TSJToggle<cr>", desc = "Toggle join/split" },
    },
  },
}
