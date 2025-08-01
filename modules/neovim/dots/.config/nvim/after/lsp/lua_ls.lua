return {
  settings = {
    Lua = {
      workspace = {
        maxPreload = 10000,
        checkThirdParty = false,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
}
