return {
  {
    "numToStr/Comment.nvim",
    tag = "v0.7.0",
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
      { "g>", mode = { "n", "v" } },
      { "g<", mode = { "n", "v" } },
    },
    opts = function(_, opts)
      local commentstring = _G.prequire("ts_context_commentstring.integrations.comment_nvim")
      opts.commentstring = commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
      return opts
    end,
  },
}
