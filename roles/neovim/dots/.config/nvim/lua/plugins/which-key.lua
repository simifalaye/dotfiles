local lz = require("utils.lazy").new("which-key", function()
  require("which-key").setup({
    preset = "helix",
    icons = {
      rules = false,
    },
    disable = { filetypes = { "TelescopePrompt" } },
    plugins = {
      presets = {
        nav = false,
        g = false,
      }
    }
  })
  return true
end)
lz:autocmds({ "VimEnter" })

lz:key("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Show Buffer-local Keys" })
