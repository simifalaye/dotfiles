--[[

Neovim inint file
Nvim version: 0.8.0+
Maintainer: simifalaye

--]]

-- Load modules in order
for _, source in ipairs {
  "globals",
  "core.options",
  "core.lazy", -- NOTE: Map leader must be set before this point
  "core.commands",
  "core.autocommands",
  "core.keymaps",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end
