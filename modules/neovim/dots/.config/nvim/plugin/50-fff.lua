if true then
  return
end

-- Config
vim.g.fff = {
  prompt = "> ",
  title = "Files",
  layout = {
    preview_position = "right",
    flex = {
      size = 130,
      wrap = "top",
    },
  },
}

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      vim.cmd.packadd("fff.nvim")
      require("fff.download").download_or_build_binary()
    end
  end,
})

vim.pack.add({
  {
    src = "https://github.com/dmtrKovalenko/fff.nvim",
  },
})

vim.keymap.set("n", "<leader>ff", function()
  require("fff").find_files()
end, { desc = "Find" })
vim.keymap.set("n", "<leader><leader>", function()
  require("fff").find_files()
end, { desc = "Find files" })
vim.keymap.set({ "n" }, "<leader>/", function()
  require("fff").live_grep()
end, { desc = "Live grep" })
vim.keymap.set({ "n" }, "<leader>*", function()
  require("fff").live_grep({ query = vim.fn.expand("<cword>") })
end, { desc = "Live grep" })

local mb_ok, _ = pcall(require, "minibuffer")
if mb_ok then
  local picker_ui = require("fff.picker_ui")
  picker_ui.open = require("minibuffer.integrations.fff")
end
