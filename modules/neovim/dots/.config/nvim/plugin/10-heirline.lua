MiniDeps.add({
  source = "rebelot/heirline.nvim",
})

MiniDeps.later(function()
  local heirline = require("heirline")
  local hl_utils = require("utils.hl")

  local function get_term_color(num, default)
    default = default or "#000000"
    local term_color = vim.g["terminal_color_" .. tostring(num)]
    if term_color then
      return term_color
    end
    return default
  end

  local function get_colors()
    return {
      fore = hl_utils.get_hl_color("fg", { "StatusLine", "Normal" }, "#000000"),
      back1 = hl_utils.get_hl_color("bg", { "StatusLine", "Normal" }, "#000000"),
      back2 = hl_utils.get_hl_color("bg", { "StatusLineNC" }, "#000000"),
      -- ANSI terminal colors
      black = get_term_color(0, "#000000"),
      red = get_term_color(1, "#d70000"),
      green = get_term_color(2, "#5fd700"),
      yellow = get_term_color(3, "#d7d700"),
      blue = get_term_color(4, "#0000d7"),
      magenta = get_term_color(5, "#d700d7"),
      cyan = get_term_color(6, "#00d7d7"),
      white = get_term_color(7, "#d7d7d7"),
      bright_black = get_term_color(8, "#808080"),
      bright_red = get_term_color(9, "#ff0000"),
      bright_green = get_term_color(10, "#00ff00"),
      -- Utility colors
      diag_warn = hl_utils.get_hl_color("fg", "DiagnosticWarn", "#000000"),
      diag_error = hl_utils.get_hl_color("fg", "DiagnosticError", "#000000"),
      diag_hint = hl_utils.get_hl_color("fg", "DiagnosticHint", "#000000"),
      diag_info = hl_utils.get_hl_color("fg", "DiagnosticInfo", "#000000"),
      git_del = hl_utils.get_hl_color("fg", "diffDeleted", "#000000"),
      git_add = hl_utils.get_hl_color("fg", "diffAdded", "#000000"),
      git_change = hl_utils.get_hl_color("fg", "diffChanged", "#000000"),
      directory = hl_utils.get_hl_color("fg", "Directory", "#000000"),
    }
  end

  -- Set up Heirline colors
  heirline.load_colors(get_colors())

  -- Update highlights on colorscheme change
  local grp = vim.api.nvim_create_augroup("user_plugin_heirline", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Reset heirline colors on colorscheme change",
    group = grp,
    callback = function()
      heirline.load_colors(get_colors())
      heirline.reset_highlights()
      vim.cmd("redrawstatus")
    end,
  })

  local os_sep = package.config:sub(1, 1)
  local api = vim.api
  local fn = vim.fn
  local bo = vim.bo

  local conditions = require("heirline.conditions")

  --
  -- Components
  --

  -- Flexible components priorities
  local priority = {
    CurrentPath = 60,
    Git = 40,
    WorkDir = 25,
    Lsp = 10,
  }

  local Align, Space, Null, ReadOnly
  do
    Null = { provider = "" }
    Align = { provider = "%=" }
    Space = setmetatable({ provider = " " }, {
      __call = function(_, n)
        return { provider = string.rep(" ", n) }
      end,
    })
    ReadOnly = {
      condition = function()
        return not bo.modifiable or bo.readonly
      end,
      provider = "",
      hl = { fg = "red" },
    }
  end

  local Mode, ViMode, FileSize, MacroRec, SearchCount
  do
    ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        colors = function(m)
          local c = {
            n = "blue",
            i = "green",
            v = "magenta",
            V = "magenta",
            ["\22"] = "magenta",
            c = "cyan",
            R = "red",
            t = "bright_black",
          }
          return c[m] or "yellow"
        end,
      },
      provider = "▌",
      hl = function(self)
        return { fg = self.colors(self.mode) }
      end,
    }

    FileSize = {
      -- Only show if buffer has a file
      condition = function()
        return vim.fn.empty(vim.fn.expand("%:p")) == 0
      end,
      provider = function()
        local bytes = vim.fn.getfsize(vim.fn.expand("%:p"))
        if bytes < 0 then
          return ""
        end
        -- Convert to human-readable size
        local function human(size)
          local units = { "B", "K", "M", "G", "T" }
          local i = 1
          while size >= 1024 and i < #units do
            size = size / 1024
            i = i + 1
          end
          return string.format("%.1f%s", size, units[i])
        end
        return human(bytes)
      end,
      hl = { fg = "fore", bold = true },
    }

    MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
      end,
      provider = function()
        return "  " .. vim.fn.reg_recording() .. " "
      end,
      hl = { fg = "back1", bg = "blue" },
      update = {
        "RecordingEnter",
        "RecordingLeave",
      },
    }

    SearchCount = {
      condition = function(self)
        if vim.o.cmdheight ~= 0 then
          return false
        end
        local lines = api.nvim_buf_line_count(0)
        if lines > 50000 then
          return
        end

        local query = fn.getreg("/")
        if query == "" then
          return
        end

        if query:find("@") then
          return
        end

        local search_count = fn.searchcount({ recompute = 1, maxcount = -1 })
        local active = false
        if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
          active = true
        end
        if not active then
          return
        end

        query = query:gsub([[^\V]], "")
        query = query:gsub([[\<]], ""):gsub([[\>]], "")

        self.query = query
        self.count = search_count
        return true
      end,
      {
        provider = function(self)
          return table.concat({
            " ",
            self.count.current,
            "/",
            self.count.total,
            " ",
          })
        end,
        hl = { fg = "back1", bg = "blue" },
      },
    }

    Mode = {
      fallthrough = false,
      MacroRec,
      SearchCount,
      { ViMode, FileSize },
    }
  end

  local FileNameBlock, CurrentPath, FileName, HelpFileName, TerminalName, FileType
  do
    local FileIcon = {
      condition = function()
        return not ReadOnly.condition()
      end,
      init = function(self)
        local filename = self.filename
        local extension = fn.fnamemodify(filename, ":e")
        local has_devicons, devicons = pcall(require, "nvim-web-devicons")
        if has_devicons then
          self.icon, self.icon_color =
            devicons.get_icon_color(filename, extension, { default = true })
        else
          self.icon = "󰈔"
          self.icon_color = "green"
        end
      end,
      provider = function(self)
        if self.icon then
          return self.icon .. " "
        end
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local WorkDir = {
      condition = function(self)
        if bo.buftype == "" then
          return self.pwd
        end
      end,
      hl = { fg = "bright_black", bold = true },
      flexible = priority.WorkDir,
      {
        provider = function(self)
          return self.pwd
        end,
      },
      {
        provider = function(self)
          return fn.pathshorten(self.pwd)
        end,
      },
      Null,
    }

    CurrentPath = {
      condition = function(self)
        if bo.buftype == "" then
          return self.current_path
        end
      end,
      hl = { fg = "directory", bold = true },
      flexible = priority.CurrentPath,
      {
        provider = function(self)
          return self.current_path
        end,
      },
      {
        provider = function(self)
          return fn.pathshorten(self.current_path, 2)
        end,
      },
      { provider = "" },
    }

    FileName = {
      provider = function(self)
        return self.filename
      end,
      hl = { fg = "fore", bold = true },
    }

    HelpFileName = {
      condition = function()
        return vim.bo.filetype == "help"
      end,
      provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
      end,
      hl = { fg = "blue" },
    }

    TerminalName = {
      provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
      end,
      hl = { fg = "blue", bold = true },
    }

    FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = "magenta", bold = true },
    }

    FileNameBlock = {
      { FileIcon, WorkDir, CurrentPath, FileName },
      -- This means that the statusline is cut here when there's not enough space.
      { provider = "%<" },
    }
  end

  local Ruler = {
    -- :help 'statusline'
    -- ------------------
    -- %-2 : make item takes at least 2 cells and be left justified
    -- %l  : current line number
    -- %L  : number of lines in the buffer
    -- %c  : column number
    -- %V  : virtual column number as -{num}.  Not displayed if equal to '%c'.
    provider = " %9(%l:%L%)",
    hl = { bold = true },
  }

  local ScrollPercentage = {
    condition = function()
      return conditions.width_percent_below(4, 0.035)
    end,
    -- %P  : percentage through file of displayed window
    provider = " %3(%P%)",
    hl = { fg = "fore", bg = "back1" },
  }

  local FileProperties = {
    provider = function(self)
      local encoding = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding)
        or vim.o.encoding
      local fileformat = vim.bo.fileformat

      self.encoding = string.upper(encoding)
      if fileformat == "dos" then
        self.fileformat = "CRLF"
      elseif fileformat == "mac" then
        self.fileformat = "CR"
      else -- 'unix'
        self.fileformat = "LF"
      end

      local sep = (self.fileformat and self.encoding) and " " or ""
      return table.concat({ " ", self.fileformat or "", sep, self.encoding or "", " " })
    end,
  }

  local Diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
      error_icon = fn.sign_getdefined("DiagnosticSignError")[1].text,
      warn_icon = fn.sign_getdefined("DiagnosticSignWarn")[1].text,
      info_icon = fn.sign_getdefined("DiagnosticSignInfo")[1].text,
      hint_icon = fn.sign_getdefined("DiagnosticSignHint")[1].text,
    },
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        if self.errors > 0 then
          return table.concat({ self.error_icon, self.errors, " " })
        end
      end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self)
        if self.warnings > 0 then
          return table.concat({ self.warn_icon, self.warnings, " " })
        end
      end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self)
        if self.info > 0 then
          return table.concat({ self.info_icon, self.info, " " })
        end
      end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self)
        if self.hints > 0 then
          return table.concat({ self.hint_icon, self.hints, " " })
        end
      end,
      hl = { fg = "diag_hint" },
    },
  }

  local Git
  do
    local GitBranch = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.git_status = vim.b.gitsigns_status_dict
      end,
      hl = { fg = "magenta", bold = true },
      provider = function(self)
        return table.concat({ " ", self.git_status.head })
      end,
    }

    local GitChanges = {
      condition = function(self)
        if conditions.is_git_repo() then
          self.git_status = vim.b.gitsigns_status_dict
          local has_changes = self.git_status.added ~= 0
            or self.git_status.removed ~= 0
            or self.git_status.changed ~= 0
          return has_changes
        end
      end,
      provider = "  ",
      hl = { fg = "git_change", bold = true },
    }

    Git = { GitBranch, GitChanges }
  end

  local Lsp
  do
    local LspServer = {
      Space,
      {
        provider = function(self)
          local names = self.lsp_names
          if #names == 1 then
            names = names[1]
          else
            names = table.concat(names, ", ")
          end
          return names
        end,
      },
      Space(2),
      hl = { fg = "blue", bold = true },
    }

    Lsp = {
      condition = conditions.lsp_attached,
      init = function(self)
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        self.lsp_names = names
      end,
      hl = function(_)
        return { fg = "blue", bold = true }
      end,
      flexible = priority.Lsp,
      LspServer,
    }
  end

  --
  -- Statuslines
  --

  local InactiveStatusLine = {
    condition = conditions.is_not_active,
    Space,
    {
      provider = function()
        local filename = api.nvim_buf_get_name(0)
        return fn.fnamemodify(filename, ":t")
      end,
      hl = { fg = "fore", bold = true },
    },
    Align,
    Ruler,
    Space,
  }

  local SpecialStatusline = {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      })
    end,
    FileType,
    Space,
    HelpFileName,
    Align,
    ScrollPercentage,
    Space,
  }

  local TerminalStatusline = {
    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    hl = { bg = "back2" },
    -- Quickly add a condition to the ViMode to only show it when buffer is active!
    { condition = conditions.is_active, ViMode, Space },
    FileType,
    Space,
    TerminalName,
    Align,
  }

  local StatusLines = {
    fallthrough = false,
    init = function(self)
      local pwd = fn.getcwd(0)
      local current_path = api.nvim_buf_get_name(0)

      if current_path == "" then
        self.pwd = fn.fnamemodify(pwd, ":~")
        self.current_path = nil
        self.filename = " [No Name]"
      elseif current_path and current_path:find(pwd, 1, true) then
        self.filename = fn.fnamemodify(current_path, ":t")
        self.current_path = fn.fnamemodify(current_path, ":~:.:h")
        self.pwd = fn.fnamemodify(pwd, ":~") .. os_sep
        if self.current_path == "." then
          self.current_path = nil
        else
          self.current_path = self.current_path .. os_sep
        end
      else
        self.pwd = nil
        self.filename = fn.fnamemodify(current_path, ":t")
        self.current_path = fn.fnamemodify(current_path, ":~:.:h") .. os_sep
      end
    end,
    hl = { fg = "fore", bg = "back1" },
    SpecialStatusline,
    TerminalStatusline,
    InactiveStatusLine,
    {
      Mode,
      Space,
      FileNameBlock,
      Ruler,
      ScrollPercentage,
      Align,
      Diagnostics,
      FileProperties,
      Git,
      Lsp,
    },
  }

  require("heirline").setup({
    statusline = StatusLines,
  })
end)
