local lsp = require("utils.lsp")

local efm = false
local efm_fmt = false
local efm_cfg = {
  cmd = { "efm-langserver" },
  name = "efm",
  root_patterns = {},
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    languages = {
      bash = {},
    },
  },
}

if vim.fn.executable("shellcheck") == 1 then
  table.insert(efm_cfg.settings.languages.bash, {
    prefix = "shellcheck",
    lintSource = "shellcheck",
    lintCommand = "shellcheck --color=never --format=gcc -",
    lintIgnoreExitCode = true,
    lintStdin = true,
    lintFormats = {
      "-:%l:%c: %trror: %m",
      "-:%l:%c: %tarning: %m",
      "-:%l:%c: %tote: %m",
    },
  })
  efm = true
end
if vim.fn.executable("shfmt") == 1 then
  table.insert(efm_cfg.settings.languages.bash, {
    formatCommand = "shfmt -i 2 -ci -bn -filename '${INPUT}' -",
    formatStdin = true,
  })
  efm_fmt = true
  efm = true
end

if efm then
  lsp.start(efm_cfg)
end
lsp.start({
  name = "bashls",
  cmd = { "bash-language-server", "start" },
  root_patterns = {},
  single_file_support = true,
  init_options = {
    documentFormatting = not efm_fmt,
    documentRangeFormatting = not efm_fmt,
  },
  settings = {
    bashIde = {
      -- Glob pattern for finding and parsing shell script files in the workspace.
      -- Used by the background analysis features across files.

      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
    },
  },
})
