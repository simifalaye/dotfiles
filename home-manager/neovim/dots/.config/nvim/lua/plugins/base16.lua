local default_theme = "base16-default"
local tinty_installed = vim.fn.executable("tinty") == 1
local function get_tinty_theme()
  if not tinty_installed then
    return default_theme
  end
  local theme_name = vim.fn.system("tinty current &> /dev/null && tinty current")
  if vim.v.shell_error ~= 0 then
    return default_theme
  else
    return vim.trim(theme_name)
  end
end

-- Set require vim options
vim.o.termguicolors = true
vim.g.tinted_colorspace = 256

-- Load base16 with configuration
require("base16-colorscheme").with_config({
  telescope = true,
  telescope_borders = true,
})

-- Set colorscheme
vim.cmd("colorscheme " .. get_tinty_theme())

-- Handle theme changes on focus gained
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local new_theme_name = get_tinty_theme()
    local current_theme_name = vim.g.colors_name

    if current_theme_name ~= new_theme_name then
      vim.schedule(function()
        vim.cmd("colorscheme " .. new_theme_name)
      end)
    end
  end,
})
