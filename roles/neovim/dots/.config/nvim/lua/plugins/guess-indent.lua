local function init()
  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
  })
end

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  desc = "Load guess_indent",
  once = true,
  callback = function()
    init()
  end,
})
