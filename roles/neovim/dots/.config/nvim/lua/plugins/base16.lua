vim.o.termguicolors = true

-- Load base16 with configuration
require("base16-colorscheme").with_config({
  telescope = true,
  telescope_borders = true,
})

-- Use tinty helper if installed
local set_theme_path = vim.env.TINTY_SCHEME_FILE
if vim.fn.filereadable(set_theme_path) == 1 then
  local fs = require("utils.fs")

  vim.cmd("colorscheme " .. fs.read_file(set_theme_path))
  -- Autoload new theme if updated
  fs.watch(set_theme_path, {
    on_event = function()
      vim.schedule(function()
        if vim.fn.filereadable(set_theme_path) == 1 then
          vim.cmd("colorscheme " .. fs.read_file(set_theme_path))
        end
      end)
    end,
  })
else
  vim.cmd("colorscheme base16-default-dark")
end
