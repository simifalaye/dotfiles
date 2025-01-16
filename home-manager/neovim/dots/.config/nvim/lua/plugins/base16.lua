return {
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local default_theme = "base16-default-dark"
      local tinty_current_file = vim.env.TINTY_CURRENT_FILE
      local tinty_installed = vim.fn.executable("tinty") == 1 and tinty_current_file
      local function get_tinty_theme()
        if not tinty_installed then
          return default_theme
        end

        local theme = require("utils.fs").read_file(vim.env.TINTY_CURRENT_FILE)
        if not theme then
          return default_theme
        end
        return vim.trim(theme)
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

      -- Handle theme changes by watching the theme file
      if tinty_installed then
        require("utils.fs").watch_with_function(tinty_current_file, function(_, _, _)
          vim.schedule(function()
            local new_theme_name = get_tinty_theme()
            vim.cmd("colorscheme " .. new_theme_name)
          end)
        end)
      end
    end,
  },
}

