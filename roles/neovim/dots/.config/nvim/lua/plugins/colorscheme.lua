return {
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    init = function()
      vim.o.termguicolors = true
    end,
    config = function()
      local fs = require("utils.fs")

      -- Load base16 with configuration
      require("base16-colorscheme").with_config({
        telescope = true,
        telescope_borders = true,
      })

      -- Use tinty helper if installed
      local set_theme_path = vim.env.HOME
        .. "/.local/share/tinted-theming/tinty/current_scheme"
      if vim.fn.filereadable(set_theme_path) == 1 then
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
    end,
  },
}
