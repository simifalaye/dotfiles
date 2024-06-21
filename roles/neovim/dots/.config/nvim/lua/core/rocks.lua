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
end

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

vim.cmd([[packadd base16-nvim]])
vim.cmd([[packadd mason.nvim]])
vim.cmd([[packadd mason-tool-installer.nvim]])
vim.cmd([[packadd mason-lspconfig.nvim]])
