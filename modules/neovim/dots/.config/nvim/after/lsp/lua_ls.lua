---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      codeLens = { enable = true },
      workspace = {
        maxPreload = 10000,
        checkThirdParty = false,
        -- Don't analyze code from submodules
        ignoreSubmodules = true,
        -- Add Neovim's methods for easier code writing
        library = { vim.env.VIMRUNTIME },
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
