return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      workspace = {
        maxPreload = 8000,
        checkThirdParty = false, -- fixes popup issue
      },
    },
  },
}
