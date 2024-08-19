-- Enables 24-bit RGB color in the `TUI`
vim.o.termguicolors = true
-- Access colors present in 256 colorspace
vim.g.base16_colorspace = 256

-- Use tinty helper if installed
if vim.fn.filereadable(vim.env.TINTY_SCHEME_FILE) == 1 then
  local fs = require("utils.fs")

  vim.cmd("colorscheme " .. fs.read_file(vim.env.TINTY_SCHEME_FILE))
  -- Autoload new theme if updated
  fs.watch(vim.env.TINTY_SCHEME_FILE, {
    on_event = function()
      vim.schedule(function()
        if vim.fn.filereadable(vim.env.TINTY_SCHEME_FILE) == 1 then
          vim.cmd("colorscheme " .. fs.read_file(vim.env.TINTY_SCHEME_FILE))
        end
      end)
    end,
  })
else
  vim.cmd("colorscheme base16-default-dark")
end
