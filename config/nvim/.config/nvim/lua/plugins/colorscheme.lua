return {
  {
    "RRethy/nvim-base16",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local utils = require("utils")
      local fn = vim.fn
      local cmd = vim.cmd
      local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
      local is_set_theme_file_readable = fn.filereadable(fn.expand(set_theme_path)) == 1
          and true
        or false

      -- Load the scheme
      if is_set_theme_file_readable then
        utils.notify("Found theme script, sourcing...", vim.log.levels.DEBUG)
        cmd("let base16colorspace=256")
        cmd("source " .. set_theme_path)
      else
        utils.notify(
          "No base16 theme script found, using default-dark",
          vim.log.levels.DEBUG
        )
        cmd("let base16colorspace=256")
        cmd("colorscheme base16-default-dark")
      end
    end,
  },
}
