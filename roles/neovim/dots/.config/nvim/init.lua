--[[

Neovim inint file
Nvim version: 0.10.0+
Maintainer: simifalaye

--]]

-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
pcall(function()
  vim.loader.enable()
end)

---Restore 'shada' option and read from shada once
---@return true
local function _rshada()
  vim.cmd.set("shada&")
  vim.cmd.rshada()
  return true
end
vim.opt.shada = ""
vim.defer_fn(_rshada, 100)
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("user_shada_restore", {}),
  once = true,
  callback = _rshada,
})

-- Load core modules
require("core.globals")
require("core.options")
require("core.autocommands")
require("core.commands")
require("core.keymaps")

-- Setup rocks.nvim
do
  -- Specifies where to install/use rocks.nvim
  local install_location =
    vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "rocks")

  -- Set up configuration options related to rocks.nvim (recommended to leave as default)
  local rocks_config = {
    rocks_path = vim.fs.normalize(install_location),
    luarocks_binary = vim.fs.joinpath(install_location, "bin", "luarocks"),
  }

  vim.g.rocks_nvim = rocks_config

  -- Configure the package path (so that plugin code can be found)
  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

  -- Configure the C path (so that e.g. tree-sitter parsers can be found)
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

  -- Load all installed plugins, including rocks.nvim itself
  vim.opt.runtimepath:append(
    vim.fs.joinpath(
      rocks_config.rocks_path,
      "lib",
      "luarocks",
      "rocks-5.1",
      "rocks.nvim",
      "*"
    )
  )
end

-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
  local rocks_location =
    vim.fs.joinpath(vim.fn.stdpath("cache") --[[@as string]], "rocks.nvim")

  if not vim.uv.fs_stat(rocks_location) then
    -- Pull down rocks.nvim
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/nvim-neorocks/rocks.nvim",
      rocks_location,
    })
  end

  -- If the clone was successful then source the bootstrapping script
  assert(
    vim.v.shell_error == 0,
    "rocks.nvim installation failed. Try exiting and re-entering Neovim!"
  )

  vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))

  vim.fn.delete(rocks_location, "rf")

  -- Run sync
  vim.defer_fn(function()
    vim.cmd([[Rocks sync]])
  end, 500)
end

-- Configure rocks.nvim
vim.g.rocks_nvim = {
  -- rocks-treesitter.nvim config
  treesitter = {
    auto_highlight = "all",
    auto_install = "true",
    parser_map = {
      c = "c",
      cc = "cpp",
      cpp = "cpp",
    },
  },
}
