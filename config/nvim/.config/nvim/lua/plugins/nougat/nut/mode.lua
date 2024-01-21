local Item = require("nougat.item")
local color = require("nougat.color").get()
local on_event = require("nougat.util").on_event

-- stylua: ignore start
local modes = {
  ['n']      = {text = 'NO', group = "normal"},
  ['no']     = {text = 'OP', group = "normal"},
  ['nov']    = {text = 'OC', group = "normal"},
  ['noV']    = {text = 'OL', group = "normal"},
  ['no\x16'] = {text = 'OB', group = "normal"},
  ['\x16']   = {text = 'VB', group = "normal"},
  ['niI']    = {text = 'IN', group = "normal"},
  ['niR']    = {text = 'RE', group = "normal"},
  ['niV']    = {text = 'RV', group = "normal"},
  ['nt']     = {text = 'NT', group = "normal"},
  ['ntT']    = {text = 'TM', group = "normal"},
  ['v']      = {text = 'VI', group = "visual"},
  ['vs']     = {text = 'VI', group = "visual"},
  ['V']      = {text = 'VL', group = "visual"},
  ['Vs']     = {text = 'VL', group = "visual"},
  ['\x16s']  = {text = 'VB', group = "visual"},
  ['s']      = {text = 'SE', group = "visual"},
  ['S']      = {text = 'SL', group = "visual"},
  ['\x13']   = {text = 'SB', group = "visual"},
  ['i']      = {text = 'IN', group = "insert"},
  ['ic']     = {text = 'IC', group = "insert"},
  ['ix']     = {text = 'IX', group = "insert"},
  ['R']      = {text = 'RE', group = "replace"},
  ['Rc']     = {text = 'RC', group = "replace"},
  ['Rx']     = {text = 'RX', group = "replace"},
  ['Rv']     = {text = 'RV', group = "replace"},
  ['Rvc']    = {text = 'RC', group = "replace"},
  ['Rvx']    = {text = 'RX', group = "replace"},
  ['c']      = {text = 'CO', group = "command"},
  ['cv']     = {text = 'CV', group = "command"},
  ['r']      = {text = 'PR', group = "command"},
  ['rm']     = {text = 'PM', group = "command"},
  ['r?']     = {text = 'P?', group = "command"},
  ['!']      = {text = 'SH', group = "command"},
  ['t']      = {text = 'TE', group = "terminal"},
  ['-']      = {text = '--', group = "inactive"},
}
-- stylua: ignore end

local default_highlight = {
  normal = {
    bg = "fg",
    fg = "bg",
  },
  visual = {
    bg = color.yellow,
    fg = "bg",
  },
  insert = {
    bg = color.blue,
    fg = "bg",
  },
  replace = {
    bg = color.magenta,
    fg = "bg",
  },
  command = {
    bg = color.green,
    fg = "bg",
  },
  terminal = {
    bg = color.cyan,
    fg = "bg",
  },
  inactive = {
    bg = "fg",
    fg = "bg",
  },
}

local cache = {
  mode = "n",
  group = modes["n"].group,
}

local function on_mode_changed()
  local event = vim.v.event
  local old_mode, new_mode = event.old_mode, event.new_mode
  cache.mode, cache.group = new_mode, modes[new_mode].group
  if old_mode == "t" then
    vim.schedule(function()
      vim.cmd("redrawstatus")
    end)
  end
end

---@param item table
---@param ctx table
local function content(item, ctx)
  local mode = ctx.is_focused and cache.mode or "-"
  return item:config(ctx).modes[mode].text or mode
end

---@param item table
---@param ctx table
local function hl(item, ctx)
  return item:config(ctx).highlight[ctx.is_focused and cache.group or "inactive"]
end

local M = {}

---@param config? table
function M.create(config)
  on_event("ModeChanged", on_mode_changed)

  config = config or {}

  local item = Item({
    priority = config.priority,
    hidden = config.hidden,
    hl = hl,
    sep_left = config.sep_left,
    prefix = config.prefix,
    content = content,
    suffix = config.suffix,
    sep_right = config.sep_right,
    config = vim.tbl_deep_extend("keep", config.config or {}, {
      modes = modes,
      highlight = default_highlight,
    }),
    on_click = config.on_click,
    context = config.context,
  })

  return item
end

return M
