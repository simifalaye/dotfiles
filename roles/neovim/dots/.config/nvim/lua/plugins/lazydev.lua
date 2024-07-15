local lz = require("utils.lazy").new("lazydev", function()
  require("lazydev").setup({})
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    local cmp_cfg = cmp.get_config()
    table.insert(cmp_cfg.sources, {
      name = "lazydev",
      group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    })
    cmp.setup(cmp_cfg)
  end
  return true
end)
lz:fts({ "lua" })
