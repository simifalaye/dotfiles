local lz = require("utils.lazy").new("lualine", function()
  local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local str = ""
    for _, v in pairs(clients) do
      if v.name then
        str = str .. v.name .. ", "
      end
    end
    return str:sub(1, -3)
  end

  local diag_icons = require("static.icons").font.diagnostics
  local spaced = function(icon)
    return icon .. " "
  end
  require("lualine").setup({
    options = {
      theme = function()
        local hl = require("utils.hl")
        local group = hl.get(0, { name = "Normal" })
        local basic = {
          bg = group["fg"] and hl.dec2hex(group["fg"]),
          fg = group["bg"] and hl.dec2hex(group["bg"]),
        }
        local slcolor = { a = basic, b = basic, c = basic }
        return {
          normal = slcolor,
          insert = slcolor,
          visual = slcolor,
          replace = slcolor,
          command = slcolor,
          inactive = slcolor,
        }
      end,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return str:sub(1, 3)
          end,
        },
      },
      lualine_b = {
        "branch",
        -- { "diff", colored = false },
        {
          "diagnostics",
          symbols = {
            error = spaced(diag_icons.error),
            warn = spaced(diag_icons.warn),
            info = spaced(diag_icons.info),
            hint = spaced(diag_icons.hint),
          },
          colored = true,
        },
      },
      lualine_c = { { "filename", path = 1, shorting_target = 60 } },
      lualine_x = { { lsp_clients }, { "filetype", colored = false } },
      lualine_y = {},
      lualine_z = { { "%l:%c" } },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1, shorting_target = 60 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  })
  return true
end)
lz:events({ "VimEnter" })
