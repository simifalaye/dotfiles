return {
  {
    "Wansmer/treesj",
    event = "BufEnter",
    opts = {
      use_default_keymaps = false,
    },
    keys = {
      { "gJ", "<cmd>TSJJoin<cr>", desc = "Join lines (ts)" },
      { "gS", "<cmd>TSJSplit<cr>", desc = "Split lines (ts)" },
    },
  },
}
