return {
  {
    "rebelot/heirline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local hl = require("utils.hl")

      local function setup_colors()
        -- stylua: ignore start
        return {
          bright_bg = hl.normalize_fg_or_bg("bg", {"Folded"}, "#000000"),
          bright_fg = hl.normalize_fg_or_bg("fg", {"Folded"}, "#FFFFFF"),
          red = hl.normalize_fg_or_bg("fg", {"Error", "ErrorMsg"}, "#FFFFFF"),
          green = hl.normalize_fg_or_bg("fg", {"String", "ModeMsg"}, "#FFFFFF"),
          blue = hl.normalize_fg_or_bg("fg", {"Function", "Include"}, "#FFFFFF"),
          gray = hl.normalize_fg_or_bg("fg", {"NonText", "TabLine"}, "#FFFFFF"),
          orange = hl.normalize_fg_or_bg("fg", {"Constant", "Number"}, "#FFFFFF"),
          purple = hl.normalize_fg_or_bg("fg", {"Statement", "Conditional"}, "#FFFFFF"),
          cyan = hl.normalize_fg_or_bg("fg", {"Special", "FoldColumn"}, "#FFFFFF"),
          diag_warn = hl.normalize_fg_or_bg("fg", "DiagnosticWarn", "#FFFFFF"),
          diag_error = hl.normalize_fg_or_bg("fg", "DiagnosticError", "#FFFFFF"),
          diag_hint = hl.normalize_fg_or_bg("fg", "DiagnosticHint", "#FFFFFF"),
          diag_info = hl.normalize_fg_or_bg("fg", "DiagnosticInfo", "#FFFFFF"),
          git_del = hl.normalize_fg_or_bg("fg", {"Error", "ErrorMsg"}, "#FFFFFF"),
          git_add = hl.normalize_fg_or_bg("fg", {"String", "ModeMsg"}, "#FFFFFF"),
          git_change = hl.normalize_fg_or_bg("fg", {"Constant", "Number"}, "#FFFFFF"),
        }
        -- stylua: ignore end
      end
      require("utils.augroup")("user_heirline_colorscheme", {
        {
          desc = "Reload heirline colors when colorscheme changes",
          event = "ColorScheme",
          command = function()
            utils.on_colorscheme(setup_colors)
          end,
        },
      })
      local colors = setup_colors()

      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        static = {
          mode_names = {
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
          mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
          },
        },
        provider = function(self)
          return "%-2("..self.mode_names[self.mode].."%)"
        end,
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true }
        end,
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local FileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
            filename,
            extension,
            { default = true }
          )
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      }

      local FileName = {
        init = function(self)
          if not self.filename then
            self.filename = vim.api.nvim_buf_get_name(0)
          end
          self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
          if self.lfilename == "" then
            self.lfilename = "[No Name]"
          end
        end,
        hl = { fg = utils.get_highlight("Directory").fg },

        flexible = 2,

        {
          provider = function(self)
            return self.lfilename
          end,
        },
        {
          provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
          end,
        },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = "green" },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = "orange" },
        },
      }

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
          end
        end,
      }

      FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName),
        FileFlags,
        { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
      )

      local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
          error_icon = "",
          warn_icon = "",
          info_icon = "",
          hint_icon = "",
        },
        init = function(self)
          self.errors =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings =
            #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
          provider = "![",
        },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
          end,
          hl = { fg = "diag_error" },
        },
        {
          provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
          end,
          hl = { fg = "diag_warn" },
        },
        {
          provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
          end,
          hl = { fg = "diag_info" },
        },
        {
          provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
          end,
          hl = { fg = "diag_hint" },
        },
        {
          provider = "]",
        },
      }

      local Git = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,
        hl = { fg = "orange" },
        { -- git branch name
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { bold = true },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "(",
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = "git_add" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = "git_del" },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = "git_change" },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = ")",
        },
      }

      local SearchCount = {
        condition = function()
          return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
        end,
        init = function(self)
          local ok, search = pcall(vim.fn.searchcount)
          if ok and search.total then
            self.search = search
          end
        end,
        provider = function(self)
          local search = self.search
          return string.format(
            "[%d/%d]",
            search.current,
            math.min(search.total, search.maxcount)
          )
        end,
      }

      local MacroRec = {
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = "@",
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function()
            return vim.fn.reg_recording()
          end,
          hl = { fg = "green", bold = true },
        }),
        update = {
          "RecordingEnter",
          "RecordingLeave",
        },
      }

      local SearchOrMacro = {
        fallthrough = false,
        MacroRec,
        SearchCount,
      }

      local FileType = {
        condition = function ()
          return vim.bo.buftype == ""
        end,
        provider = function()
          return vim.bo.filetype
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local LSPActive = {
        condition = function()
          local clients, _ = require("utils.lsp").get_attached_clients()
          return next(clients) ~= nil
        end,
        update = { "LspAttach", "LspDetach", "BufEnter"  },
        provider = function()
          local names = {}
          local clients, _ = require("utils.lsp").get_attached_clients()
          for _, server in pairs(clients) do
            table.insert(names, server.name)
          end
          return " [" .. table.concat(names, " ") .. "]"
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local FileTypeOrLSP = {
        fallthrough = false,
        LSPActive,
        FileType,
      }

      local Ruler = {
        provider = "%l/%L:%c",
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == "help"
        end,
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = { fg = colors.blue },
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }
      ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode })

      -- Setup statuslines
      -- stylua: ignore start
      local DefaultStatusline = {
          ViMode, Space, FileNameBlock, Space, Git, Space, Diagnostics, Align,
          SearchOrMacro, Space, FileTypeOrLSP, Space, Ruler, Space,
      }
      local InactiveStatusline = {
        condition = conditions.is_not_active,
        FileType, Space, FileName, Align,
      }
      local SpecialStatusline = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
          })
        end,
        FileType, Space, HelpFileName, Align,
        SearchOrMacro
      }
      local StatusLines = {
        hl = function()
          if conditions.is_active() then
            return "StatusLine"
          else
            return "StatusLineNC"
          end
        end,
        fallthrough = false,
        SpecialStatusline, InactiveStatusline, DefaultStatusline
      }
      -- stylua: ignore end

      require("heirline").setup({
        opts = {
          colors = colors,
        },
        statusline = StatusLines,
      })
    end,
  },
}
