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

vim.keymap.set("n", "ff", function()
  require("fff").find_files()
end, { desc = "FFFind files" })
vim.keymap.set("n", "<leader><leader>", function()
  require("fff").find_files()
end)

local mb_ok, _ = pcall(require, "minibuffer")
if mb_ok then
  local picker_ui = require("fff.picker_ui")
  picker_ui.open = require("minibuffer.integrations.fff")
end
