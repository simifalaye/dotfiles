local prequire = require("utils.prequire")
return {
  {
    "numToStr/Comment.nvim",
    tag = "v0.7.0",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    opts = function(_, opts)
      -- Use ts commment string if it is installed
      local commentstring = prequire("ts_context_commentstring.integrations.comment_nvim")
      if commentstring then
        opts.pre_hook = commentstring.create_pre_hook()
      end
      return opts
    end,
  },
}
