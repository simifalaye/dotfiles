local lsp = require("utils.lsp")

lsp.start(lsp.generate_config(require("static.default_lspconfig"), {
  name = "bash_ls",
  cmd = { "bash-language-server", "start" },
  root_patterns = {},
  single_file_support = true,
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
}))
