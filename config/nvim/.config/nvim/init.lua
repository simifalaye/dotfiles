--[[

Neovim inint file
Nvim version: 0.8.0+
Maintainer: simifalaye

--]]
local utils = require("utils")

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
  "core.lazy", -- NOTE: Map leader must be set before this point
  "core.commands",
  "core.keymaps",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    utils.notify(
      "Failed to load " .. source .. "\n\n" .. fault,
      vim.log.levels.ERROR
    )
  end
end
