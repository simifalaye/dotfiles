return {
  settings = {
    ["nil"] = {
      formatting = { command = { "alejandra" } },
    },
  },
  on_attach = function(_, bufnr)
    vim.keymap.set(
      "n",
      "gq.",
      vim.lsp.buf.format,
      { desc = "Format Document", buffer = bufnr }
    )
  end,
}
