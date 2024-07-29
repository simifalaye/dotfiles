local lz = require("utils.lazy").new("guess-indent", function()
  require("guess-indent").setup({
    auto_cmd = true,
    override_editorconfig = false,
  })
  return true
end)
lz:events({ "BufReadPre" })
