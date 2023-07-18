return {
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
  on_attach_ext = function(_, bufnr)
    require("utils.map").nnoremap("g;", function()
      vim.cmd("ClangdSwitchSourceHeader")
    end, { desc = "Alt file (lsp)", buffer = bufnr})
  end,
}
