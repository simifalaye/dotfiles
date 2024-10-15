local lz = require("utils.lazy").new("autopairs", function()
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
  return true
end)
lz:events({ "InsertEnter" })
