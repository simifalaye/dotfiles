MiniDeps.now(function()
  MiniDeps.add({
    source = "tinted-theming/tinted-nvim",
  })

  -- Set require vim options

  vim.o.termguicolors = true

  -- Load base16 with configuration
  require("tinted-colorscheme").setup(nil, {
    supports = {

      tinty = true,
      tinted_shell = true,

      live_reload = true,
    },
    highlights = {
      telescope = true,
      telescope_borders = true,
    },
  })
end)
