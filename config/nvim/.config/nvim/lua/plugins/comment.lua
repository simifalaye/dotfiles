return {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "x" } },
      { "gb", mode = { "n", "x" } },
    },
    config = function()
      local comment = require("Comment")
      local ts_commentstring_ok, ts_commentstring =
        pcall(require, "ts_context_commentstring.integrations.comment_nvim")

      if ts_commentstring_ok then
        comment.setup({
          pre_hook = ts_commentstring.create_pre_hook(),
        })
      else
        comment.setup()
      end
    end,
  },
}
