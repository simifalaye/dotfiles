--- Return a function that executes a gitsigns command lazy-loading it
--first if it is not loaded
---@param cmd string builtin command to run
---@vararg any? arguments to pass to the command
---@return fun()
local gcmd = function(cmd, ...)
  local args = { ... }
  return function()
    require("gitsigns")[cmd](unpack(args))
  end
end

return {
  {
    "lewis6991/gitsigns.nvim",
    tag = "release",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    cmd = { "Gitsigns" },
    init = function()
      local m = require("utils.map")
      m.group("<leader>gh", "+hunk")
    end,
    keys = {
      {
        "ih",
        ":<C-U>Gitsigns select_hunk<CR>",
        mode = { "o", "x" },
        desc = "In Hunk",
      },
      { "]h", gcmd("next_hunk"), desc = "Next Git Hunk" },
      { "[h", gcmd("prev_hunk"), desc = "Prev Git Hunk" },
      { "<leader>ghb", gcmd("blame_line", { full = true }), desc = "Blame Line" },
      { "<leader>ghd", gcmd("diffthis"), desc = "Diff" },
      { "<leader>ghD", gcmd("diffthis", "~"), desc = "Diff HEAD" },
      { "<leader>ghp", gcmd("preview_hunk"), desc = "Preview Hunk" },
      { "<leader>ghr", gcmd("reset_hunk"), desc = "Reset Hunk" },
      { "<leader>ghR", gcmd("reset_buffer"), desc = "Reset Buff" },
      { "<leader>ghu", gcmd("undo_stage_hunk"), desc = "Undo Stage" },
      { "<leader>ghs", gcmd("stage_hunk"), desc = "Stage Hunk" },
      { "<leader>ghS", gcmd("stage_buffer"), desc = "Stage Buff" },
    },
    opts = {},
  },
}
