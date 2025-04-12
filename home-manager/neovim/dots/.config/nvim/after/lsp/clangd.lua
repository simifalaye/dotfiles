vim.lsp.enable("clangd")
return {
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
  on_attach = function(_, bufnr)
    vim.keymap.set(
      "n",
      "<localleader><localleader>",
      "<cmd>ClangdSwitchSourceHeader<CR>",
      { buffer = bufnr, desc = "Switch src/header" }
    )
  end,
}
