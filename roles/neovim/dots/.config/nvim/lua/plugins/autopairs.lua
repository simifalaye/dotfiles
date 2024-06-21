local function init()
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
end

vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Load nvim-autopairs plugin",
  once = true,
  callback = function()
    init()
  end,
})
