local M = {
  "tinted-theming/tinted-nvim",
  lazy = false,
  priority = 1000,
}

M.config = function()
  -- Set require vim options
  vim.o.termguicolors = true

  -- Load base16 with configuration
  require('tinted-colorscheme').setup(nil, {
    supports = {
      tinty = true,
      tinted_shell = true,
      live_reload = true,
    },
    highlights = {
      telescope = true,
      telescope_borders = true,
    }
  })
end

return M
