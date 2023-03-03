return {
  {
    "windwp/windline.nvim",
    event = "VeryLazy",
    config = function()
      local windline = require("windline")
      local b_components = require("windline.components.basic")
      local state = _G.WindLine.state

      local lsp_comps = require("windline.components.lsp")
      local git_comps = require("windline.components.git")

      local hl_list = {
        Black = { "white", "black" },
        White = { "black", "white" },
        Inactive = { "InactiveFg", "InactiveBg" },
        Active = { "ActiveFg", "ActiveBg" },
      }
      local basic = {}

      local breakpoint_width = 90
      basic.divider = { b_components.divider, "" }
      basic.bg = { " ", "StatusLine" }

      local colors_mode = {
        Normal = { "red", "black" },
        Insert = { "green", "black" },
        Visual = { "yellow", "black" },
        Replace = { "blue_light", "black" },
        Command = { "magenta", "black" },
      }

      basic.square_mode = {
        hl_colors = colors_mode,
        text = function()
          return { { "▊", state.mode[2] } }
        end,
      }

      basic.lsp_diagnos = {
        name = "diagnostic",
        hl_colors = {
          red = { "red", "black" },
          yellow = { "yellow", "black" },
          blue = { "blue", "black" },
        },
        width = breakpoint_width,
        text = function(bufnr)
          if lsp_comps.check_lsp(bufnr) then
            return {
              {
                lsp_comps.lsp_error({ format = "  %s", show_zero = true }),
                "red",
              },
              {
                lsp_comps.lsp_warning({ format = "  %s", show_zero = true }),
                "yellow",
              },
              {
                lsp_comps.lsp_hint({ format = "  %s", show_zero = true }),
                "blue",
              },
            }
          end
          return ""
        end,
      }
      basic.file = {
        name = "file",
        hl_colors = {
          default = hl_list.Black,
          white = { "white", "black" },
          magenta = { "magenta", "black" },
        },
        text = function(_, _, width)
          if width > breakpoint_width then
            return {
              { " ", "" },
              {
                b_components.cache_file_name("[No Name]", "unique"),
                "magenta",
              },
              { b_components.line_col_lua, "white" },
              { b_components.progress_lua, "" },
              { " ", "" },
              { b_components.file_modified(" "), "magenta" },
            }
          else
            return {
              {
                b_components.cache_file_name("[No Name]", "unique"),
                "magenta",
              },
              { " ", "" },
              { b_components.file_modified(" "), "magenta" },
            }
          end
        end,
      }
      basic.file_right = {
        hl_colors = {
          default = hl_list.Black,
          white = { "white", "black" },
          magenta = { "magenta", "black" },
        },
        text = function(_, _, width)
          if width < breakpoint_width then
            return {
              { b_components.line_col_lua, "white" },
              { b_components.progress_lua, "" },
            }
          end
        end,
      }
      basic.lsp_name = {
        width = breakpoint_width,
        name = "lsp_name",
        hl_colors = {
          magenta = { "magenta", "black" },
        },
        text = function(bufnr)
          if lsp_comps.check_lsp(bufnr) then
            return {
              { lsp_comps.lsp_name(), "magenta" },
            }
          end
          return {
            { b_components.cache_file_type({ icon = true }), "magenta" },
          }
        end,
      }

      local explorer = {
        filetypes = { "fern", "NvimTree", "netrw", "neo-tree" },
        active = {
          { "  ", { "white", "black" } },
        },
        --- show active components when the window is inactive
        always_active = true,
        --- It will display a last window statusline even that window should inactive
        show_last_status = true,
      }

      local default = {
        filetypes = { "default" },
        active = {
          basic.square_mode,
          basic.file,
          basic.lsp_diagnos,
          basic.divider,
          basic.file_right,
          basic.lsp_name,
          {
            git_comps.git_branch(),
            { "magenta", "black" },
            breakpoint_width,
          },
          { " ", hl_list.Black },
          basic.square_mode,
        },
        inactive = {
          { b_components.full_file_name, hl_list.Inactive },
          basic.file_name_inactive,
          basic.divider,
          basic.divider,
          { b_components.line_col, hl_list.Inactive },
          { b_components.progress, hl_list.Inactive },
        },
      }

      windline.setup({
        colors_name = function(colors)
          return colors
        end,
        statuslines = {
          default,
          explorer,
        },
      })
    end,
  },
}
