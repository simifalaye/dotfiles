--[[

Neovim inint file
Nvim version: 0.9.0+
Maintainer: simifalaye

--]]

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

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
  "core.autocommands",
  "core.commands",
  "core.rocks",
  "core.keymaps",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.notify("Failed to load " .. source .. "\n\n" .. fault, vim.log.levels.ERROR)
  end
end
