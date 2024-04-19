return {
  cmd = {
    "clangd",
    "--background-index",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  keys = {
    {
      "<localleader>A",
      "<cmd>ClangdSwitchSourceHeader<CR>",
      desc = "Alt file (lsp)",
    },
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
}
