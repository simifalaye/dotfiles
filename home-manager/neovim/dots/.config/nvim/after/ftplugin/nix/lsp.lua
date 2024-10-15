local lsp = require("utils.lsp")
lsp.start({
  name = "nills",
  cmd = { "nil" },
  filetypes = { "nix" },
  single_file_support = true,
  root_patterns = {
    "flake.nix",
  },
  settings = {
    ["nil"] = {
      formatting = { command = { "alejandra" } },
    },
  },
  on_attach = function(_, buf)
    vim.keymap.set(
      "n",
      "gq.",
      vim.lsp.buf.format,
      { desc = "Format Document", buffer = buf }
    )
  end,
})
