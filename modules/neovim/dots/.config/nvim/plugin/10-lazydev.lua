MiniDeps.now(function()
  MiniDeps.add({
    source = "folke/lazydev.nvim",
  })

  require("lazydev").setup({
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end)
