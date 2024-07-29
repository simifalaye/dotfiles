vim.opt.signcolumn = "no"

local mini_diff = require("mini.diff")
mini_diff.setup({
  view = {
    style = "number",
  },
})

local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end

vim.keymap.set("n", "ght", mini_diff.toggle_overlay, { desc = "Toggle Diff" })
