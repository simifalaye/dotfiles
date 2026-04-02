vim.pack.add({
  {
    src = "https://github.com/windwp/nvim-autopairs",
    version = vim.version.range("*"),
  },
}, { load = function() end })

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.cmd.packadd("nvim-autopairs")
    require("nvim-autopairs").setup({
      check_ts = true,
      ts_config = { java = false },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = ([[ [%'%"%)%>%]%)%}%,] ]]):gsub("%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })
  end,
})
