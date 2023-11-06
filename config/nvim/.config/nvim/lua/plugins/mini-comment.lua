return {
  {
    "echasnovski/mini.comment",
    version = "*",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle linewise" },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
          or vim.bo.commentstring
        end,
      },
    },
  },
}
