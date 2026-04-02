if true then
  return
end

vim.pack.add({
  {
    src = "https://github.com/simifalaye/minibuffer.nvim",
  },
})

local minibuffer = require("minibuffer")

vim.ui.select = require("minibuffer.builtin.ui_select")
vim.ui.input = require("minibuffer.builtin.ui_input")

vim.keymap.set(
  "n",
  "<M-;>",
  require("minibuffer.builtin.cmdline"),
  { desc = "Command Picker" }
)
vim.keymap.set("n", "<M-.>", function()
  minibuffer.resume(true)
end, { desc = "Picker Resume" })
