return {
  {
    "akinsho/git-conflict.nvim",
    lazy = false,
    version = "*",
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]n",
        prev = "[n",
      },
    },
  },
}
