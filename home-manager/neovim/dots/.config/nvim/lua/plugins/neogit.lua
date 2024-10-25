local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
  wk.add({ { "<leader>g", group = "+git" } })
end

local lz = require("utils.lazy").new("neogit", function()
  require("neogit").setup({})
  return true
end)

lz:cmds({ "Neogit" })
lz:key("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit" })
