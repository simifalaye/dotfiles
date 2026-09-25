local lazy = require("utils.lazy")

lazy.now(function()
  vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
  })
  require("tokyonight").setup({
    style = "night",     -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
    light_style = "day", -- The theme is used when the background is set to light
    --- You can override specific color groups to use other groups or a hex color
    --- function will be called with a ColorScheme table
    ----@param colors ColorScheme
    on_colors = function(_) end,
    --- You can override specific highlights to use other groups or a hex color
    --- function will be called with a Highlights and ColorScheme table
    ----@param highlights tokyonight.Highlights
    ----@param colors ColorScheme
    on_highlights = function(highlights, colors)
      highlights.WinBar = {
        bg = colors.bg,
      }
      highlights.WinBarNC = {
        bg = colors.bg,
      }
    end,
  })
  vim.cmd("colorscheme tokyonight")
end)
