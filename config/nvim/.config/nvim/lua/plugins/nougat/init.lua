return {
  {
    "MunifTanjim/nougat.nvim",
    lazy = false,
    config = function()
      local nougat = require("nougat")
      local core = require("nougat.core")
      local Bar = require("nougat.bar")
      local Item = require("nougat.item")
      local get_hl_def = require("nougat.color").get_hl_def
      local icons = require("static.icons")

      local nut = {
        mode = require("plugins.nougat.nut.mode"),
        spacer = require("nougat.nut.spacer"),
        truncation_point = require("nougat.nut.truncation_point"),
        diagnostic_count = require("nougat.nut.buf.diagnostic_count"),
        filename = require("plugins.nougat.nut.filename"),
        filestatus = require("nougat.nut.buf.filestatus"),
        filetype = require("nougat.nut.buf.filetype"),
        gitbranch = require("nougat.nut.git.branch"),
        gitstatus = require("nougat.nut.git.status"),
        lsp_servers = require("plugins.nougat.nut.lsp_servers"),
        search_or_macro = require("plugins.nougat.nut.search_or_macro"),
      }

      local color = require("nougat.color").get() ---@module 'nougat.color'

      local stl = Bar("statusline", { hl = { bg = color.bg1, fg = color.fg2 } })
      local mode = stl:add_item(nut.mode.create({
        prefix = " ",
        suffix = " ",
        priority = 9,
      }))
      local filename = stl:add_item(nut.filename.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        prefix = " ",
        suffix = " ",
        config = {
          modifier = ":t",
          alt_buf_modifier = ":.",
        },
        priority = 10,
      }))
      local filestatus = stl:add_item(nut.filestatus.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        suffix = " ",
        config = {
          modified = "[+]",
          nomodifiable = "[-]",
          readonly = "[x]",
          sep = "",
        },
        priority = 8,
      }))
      local filetype = nut.filetype.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        hidden = function(_, _)
          return vim.bo.buftype ~= ""
        end,
        priority = 9,
      })
      local gitbranch = nut.gitbranch.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        hidden = function(_, _)
          if vim.bo.buftype ~= "" then
            return true
          end
          local file = vim.fn.expand("%:p")
          return file == "" or not require("utils.fs").proj_dir(file, { ".git/" })
        end,
        prefix = "  ",
        priority = 0,
      })
      local gitstatus = nut.gitstatus.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        content = {
          nut.gitstatus.count("added", {
            hl = { fg = color.green },
            prefix = " +",
          }),
          nut.gitstatus.count("changed", {
            hl = { fg = color.blue },
            prefix = " ~",
          }),
          nut.gitstatus.count("removed", {
            hl = { fg = color.red },
            prefix = " -",
          }),
        },
        priority = 0,
      })
      stl:add_item(Item({
        hidden = function(_, ctx)
          if (filetype:hidden(ctx)) then
            return true
          end
          return gitbranch:hidden(ctx)
        end,
        prefix = "(",
        content = {
          filetype,
          Item({
            hidden = gitbranch,
            content = ",",
          }),
          gitbranch,
          gitstatus,
        },
        suffix = ")",
        priority = 8,
      }))
      stl:add_item(nut.spacer.create())
      stl:add_item(nut.truncation_point.create())
      stl:add_item(nut.search_or_macro.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        priority = 2,
      }))
      stl:add_item(nut.diagnostic_count.create({
        hidden = false,
        hl = { bg = color.bg1, fg = color.fg2 },
        prefix = " ",
        suffix = " ",
        config = {
          error = {
            prefix = icons.font.error,
            suffix = "",
            fg = get_hl_def("DiagnosticError").fg or color.red,
          },
          warn = {
            prefix = icons.font.warn,
            suffix = "",
            fg = get_hl_def("DiagnosticWarn").fg or color.yellow,
          },
          info = {
            prefix = icons.font.info,
            suffix = "",
            fg = get_hl_def("DiagnosticInfo").fg or color.blue,
          },
          hint = {
            prefix = icons.font.hint,
            suffix = "",
            fg = get_hl_def("DiagnosticHint").fg or color.cyan,
          },
          severity = vim.diagnostic.severity.COMBINED,
        },
        priority = 5,
      }))
      stl:add_item(nut.lsp_servers.create({
        hl = { bg = color.bg1, fg = color.fg2 },
        priority = 1,
      }))
      stl:add_item(Item({
        hl = { bg = color.bg1, fg = color.fg2 },
        prefix = " ",
        content = core.group({
          core.code("l"),
          ":",
          core.code("c"),
        }),
        suffix = " ",
        priority = 9,
      }))

      local stl_inactive = Bar("statusline")
      stl_inactive:add_item(mode)
      stl_inactive:add_item(filename)
      stl_inactive:add_item(filestatus)
      stl_inactive:add_item(nut.spacer.create())

      nougat.set_statusline(function(ctx)
        return ctx.is_focused and stl or stl_inactive
      end)
    end,
  },
}
