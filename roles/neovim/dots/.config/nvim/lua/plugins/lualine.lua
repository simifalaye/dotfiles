local function lsp_clients()
  local clients = require("utils.lsp").get_attached_clients()
  local str = ""
  for _, v in pairs(clients) do
    if v.name and v.name ~= "efm" then
      str = str .. v.name .. ", "
    end
  end
  return (string.len(str) > 0 and " " or "") .. str:sub(1, -3)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1, shorting_target = 60 } },
        lualine_x = { { lsp_clients }, "filetype", "progress" },
        lualine_y = {},
        lualine_z = { { "%l:%c" } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
}
