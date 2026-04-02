vim.pack.add({
  {
    src = "https://github.com/saghen/blink.indent",
    version = vim.version.range("*"),
  },
}, { load = function() end })

vim.api.nvim_create_autocmd({ "BufRead" }, {
  once = true,
  callback = function()
    vim.cmd.packadd("blink.indent")
  end,
})
