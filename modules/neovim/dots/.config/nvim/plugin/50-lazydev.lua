local deps = require("mini.deps")

deps.add({
  source = "folke/lazydev.nvim",
})

deps.now(function()
  local lz = require("utils.lazy").new("lazydev", function()
    require("lazydev").setup({
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end)
  lz:fts({ "lua" })
end)
