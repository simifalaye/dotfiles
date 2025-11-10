MiniDeps.now(function()
  MiniDeps.add({
    source = "nvim-mini/mini.icons",
    checkout = "stable",
  })

  local miniicons = require("mini.icons")

  package.preload["nvim-web-devicons"] = function()
    miniicons.mock_nvim_web_devicons()
    return package.loaded["nvim-web-devicons"]
  end

  miniicons.setup({
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  })
end)
