local hl = require("utils.hl")

-- stylua: ignore start
local modes = {
  ['n']      = 'NO',
  ['no']     = 'OP',
  ['nov']    = 'OC',
  ['noV']    = 'OL',
  ['no\x16'] = 'OB',
  ['\x16']   = 'VB',
  ['niI']    = 'IN',
  ['niR']    = 'RE',
  ['niV']    = 'RV',
  ['nt']     = 'NT',
  ['ntT']    = 'TM',
  ['v']      = 'VI',
  ['vs']     = 'VI',
  ['V']      = 'VL',
  ['Vs']     = 'VL',
  ['\x16s']  = 'VB',
  ['s']      = 'SE',
  ['S']      = 'SL',
  ['\x13']   = 'SB',
  ['i']      = 'IN',
  ['ic']     = 'IC',
  ['ix']     = 'IX',
  ['R']      = 'RE',
  ['Rc']     = 'RC',
  ['Rx']     = 'RX',
  ['Rv']     = 'RV',
  ['Rvc']    = 'RC',
  ['Rvx']    = 'RX',
  ['c']      = 'CO',
  ['cv']     = 'CV',
  ['r']      = 'PR',
  ['rm']     = 'PM',
  ['r?']     = 'P?',
  ['!']      = 'SH',
  ['t']      = 'TE',
}
-- stylua: ignore end

local colors = {}
local function generate_colors()
  colors = {
    fg1 = hl.normalize_fg_or_bg("fg", "StatusLine", "#000000"),
    fg2 = hl.normalize_fg_or_bg("fg", "FloatTitle", "#000000"),
    bg1 = hl.normalize_fg_or_bg("bg", "StatusLine", "#000000"),
    bg2 = hl.normalize_fg_or_bg("bg", "CursorLine", "#000000"),
    normal = hl.normalize_fg_or_bg("fg", "Conceal", "#000000"),
    insert = hl.normalize_fg_or_bg("fg", { "String", "MoreMsg" }, "#000000"),
    replace = hl.normalize_fg_or_bg("fg", { "Number", "Type" }, "#000000"),
    visual = hl.normalize_fg_or_bg("fg", { "Special", "Boolean", "Constant" }, "#000000"),
    command = hl.normalize_fg_or_bg("fg", { "Identifier" }, "#000000"),
  }
end

local function generate_theme()
  generate_colors()
  return {
    normal = {
      a = { bg = colors.normal, fg = colors.bg1, gui = "bold" },
      b = { bg = colors.bg2, fg = colors.fg2 },
      c = { bg = colors.bg2, fg = colors.fg2 },
      z = { bg = colors.bg2, fg = colors.fg2 },
    },
    insert = {
      a = { bg = colors.insert, fg = colors.bg1, gui = "bold" },
      b = { bg = colors.bg2, fg = colors.fg2 },
      c = { bg = colors.bg2, fg = colors.fg2 },
      z = { bg = colors.bg2, fg = colors.fg2 },
    },
    visual = {
      a = { bg = colors.visual, fg = colors.bg1, gui = "bold" },
      b = { bg = colors.bg2, fg = colors.fg2 },
      c = { bg = colors.bg2, fg = colors.fg2 },
      z = { bg = colors.bg2, fg = colors.fg2 },
    },
    replace = {
      a = { bg = colors.replace, fg = colors.bg1, gui = "bold" },
      b = { bg = colors.bg2, fg = colors.fg2 },
      c = { bg = colors.bg2, fg = colors.fg2 },
      z = { bg = colors.bg2, fg = colors.fg2 },
    },
    command = {
      a = { bg = colors.command, fg = colors.bg1, gui = "bold" },
      b = { bg = colors.bg2, fg = colors.fg2 },
      c = { bg = colors.bg2, fg = colors.fg2 },
      z = { bg = colors.bg2, fg = colors.fg2 },
    },
    inactive = {
      a = { bg = colors.bg1, fg = colors.fg2, gui = "bold" },
      b = { bg = colors.bg1, fg = colors.fg2 },
      c = { bg = colors.bg1, fg = colors.fg2 },
      z = { bg = colors.bg1, fg = colors.fg2 },
    },
  }
end

-- Custom Components
local function comp_mode()
  return modes[vim.fn.mode()]
end
local function comp_macro()
  return vim.fn.reg_recording() ~= "" and (" @" .. vim.fn.reg_recording()) or ""
end

-- Custom Extensions
local ext_oil = {
  sections = {
    lualine_a = { comp_mode },
    lualine_b = {
      function()
        return "oil://" .. vim.fn.getcwd()
      end,
    },
    lualine_x = {
      { comp_macro },
      "searchcount",
    },
  },
  filetypes = { "oil" },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        icons_enabled = true,
        theme = generate_theme,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { comp_mode },
        lualine_b = { "filename" },
        lualine_c = { "filetype", "branch", "diff" },
        lualine_x = {
          { comp_macro },
          "searchcount",
        },
        lualine_y = { "diagnostics" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "quickfix", "lazy", ext_oil },
    },
  },
}
