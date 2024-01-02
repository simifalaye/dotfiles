return {
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function()
      -- Load base16 with configuration
      require("base16-colorscheme").with_config({
        telescope = false,
      })

      -- Use tinted-theming/base16-shell helpers if installed
      local set_theme_path = vim.env.HOME .. "/.config/tinted-theming/set_theme.lua"
      if vim.fn.filereadable(set_theme_path) == 1 then
        vim.cmd("source " .. set_theme_path)
        -- Autoload new theme if updated
        require("utils.fs").watch(set_theme_path, {
          on_event = function()
            vim.schedule(function()
              if vim.fn.filereadable(set_theme_path) == 1 then
                vim.cmd("source " .. set_theme_path)
              end
            end)
          end,
        })
      else
        -- Fallback to using base16 env
        if vim.env.BASE16_THEME then
          vim.cmd("colorscheme base16_" .. vim.env.BASE16_THEME)
        else
          vim.cmd("colorscheme base16_default-dark")
        end
      end
    end,
  },
}
