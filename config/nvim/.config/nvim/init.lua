--[[

Neovim inint file
Nvim version: 0.9.0+
Maintainer: simifalaye

--]]

--- Inspect the contents of an object very quickly
--- ex. P({1,2,3})
--- @vararg any
--- @return any
_G.P = function(...)
  local objects, v = {}, nil
  for i = 1, select("#", ...) do
    v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end
  print(table.concat(objects, "\n"))
  return ...
end

-- Load modules in order
for _, source in ipairs({
  "core.options",
  "core.lazy",
  "core.autocommands",
  "core.commands",
  "core.keymaps",
  "core.diagnostics",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    require("utils.lib").notify(
      "Failed to load " .. source .. "\n\n" .. fault,
      vim.log.levels.ERROR
    )
  end
end
