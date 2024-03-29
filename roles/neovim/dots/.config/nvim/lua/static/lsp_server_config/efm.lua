local fs = require("efmls-configs.fs")

local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")
local cpplint = require("efmls-configs.linters.cpplint")
local clang_format = require("efmls-configs.formatters.clang_format")
local languages = {
  bash = {
    require("efmls-configs.linters.shellcheck"),
    {
      formatCommand = string.format(
        "%s -i 2 -ci -bn -filename '${INPUT}' -",
        fs.executable("shfmt")
      ),
      formatStdin = true,
    },
  },
  c = { cpplint, clang_format },
  cpp = { cpplint, clang_format },
  lua = {
    {
      formatCanRange = true,
      formatCommand = string.format(
        "%s --color Never -s ${--range-start:charStart} ${--range-end:charEnd} -",
        fs.executable("stylua")
      ),
      formatStdin = true,
      rootMarkers = { "stylua.toml", ".stylua.toml" },
    },
  },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  vue = { eslint, prettier },
  python = {
    require("efmls-configs.linters.flake8"),
    require("efmls-configs.formatters.black"),
  },
}

return {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}
