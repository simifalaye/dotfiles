local M = {}

---Wrapper of nvim_get_hl(), but does not create a highlight group
---if it doesn't exist (default to opts.create = false), and add
---new option opts.winhl_link to get highlight attributes without
---being affected by winhl
---@param ns_id integer
---@param opts table{ name: string?, id: integer?, link: boolean? }
---@return vim.api.keyset.get_hl_info: highlight attributes
function M.get(ns_id, opts)
  local no_winhl_link = opts.winhl_link == false
  opts.winhl_link = nil
  opts.create = opts.create or false
  local attr = vim.api.nvim_get_hl(ns_id, opts)
  -- We want to get true highlight attribute not affected by winhl
  if no_winhl_link then
    while attr.link do
      opts.name = attr.link
      attr = vim.api.nvim_get_hl(ns_id, opts)
    end
  end
  return attr
end

---@param attr_type 'fg'|'bg'|'ctermfg'|'ctermbg'
---@param fbg? string|number
---@param default? string|number
---@return number|string|nil
function M.normalize_fg_or_bg(attr_type, fbg, default)
  if not fbg then
    return default
  end
  local data_type = type(fbg)
  if data_type == "number" then
    if attr_type:match("^cterm") then
      return fbg >= 0 and fbg <= 255 and fbg or default
    end
    return fbg
  end
  if data_type == "string" then
    if vim.fn.hlexists(fbg) == 1 then
      return M.get(0, {
        name = fbg,
        winhl_link = false,
      })[attr_type]
    end
    if fbg:match("^#%x%x%x%x%x%x$") then
      if attr_type:match("^cterm") then
        return default
      end
      return fbg
    end
  end
  return default
end

---Normalize highlight attributes
---1. Replace `attr.fg` and `attr.bg` with their corresponding color codes
---   if they are set to highlight group names
---2. If `attr.link` used in combination with other attributes, will first
---   retrieve the attributes of the linked highlight group, then merge

---   with other attributes
---Side effect: change `attr` table
---@param attr vim.api.keyset.highlight highlight attributes
---@return table: normalized highlight attributes
function M.normalize(attr)
  if attr.link then
    local num_keys = #vim.tbl_keys(attr)
    if num_keys <= 1 then
      return attr
    end
    attr.fg = M.normalize_fg_or_bg("fg", attr.fg)
    attr.bg = M.normalize_fg_or_bg("bg", attr.bg)
    attr = vim.tbl_extend("force", M.get(0, {
      name = attr.link,
      winhl_link = false,
    }) or {}, attr)
    attr.link = nil
    return attr
  end
  local fg = attr.fg
  local bg = attr.bg
  local ctermfg = attr.ctermfg
  local ctermbg = attr.ctermbg
  attr.fg = M.normalize_fg_or_bg("fg", fg)
  attr.bg = M.normalize_fg_or_bg("bg", bg)
  attr.ctermfg = M.normalize_fg_or_bg("ctermfg", ctermfg or fg)
  attr.ctermbg = M.normalize_fg_or_bg("ctermbg", ctermbg or bg)
  return attr
end

---Wrapper of nvim_set_hl(), normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr vim.api.keyset.highlight highlight attributes
---@return nil
function M.set(ns_id, name, attr)
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

--- decimal to hex
---@param int number
---@return string -- "#rrggbb"
function M.dec2hex(int)
  assert(type(int) == "number", "dec2hex: expected number")
  return string.format("#%x", int)
end

--- hex to decimal
---@param hex string -- "#rrggbb" or "rrggbb"
---@return number
function M.hex2dec(hex)
  assert(type(hex) == "string", "hex2dec: expected string")
  hex = hex:gsub("^#", "")
  local num = tonumber(hex, 16)
  assert(num, "hex2dec: invalid hex string")
  return num
end

--- hex to rgb
---@param hex string -- "#rrggbb" or "rrggbb"
---@return {r:number, g:number, b:number}
function M.hex2rgb(hex)
  assert(type(hex) == "string", "hex2rgb: expected string")
  hex = hex:gsub("^#", "")
  hex = string.format("%06x", tonumber(hex, 16))
  return {
    r = tonumber(hex:sub(1, 2), 16),
    g = tonumber(hex:sub(3, 4), 16),
    b = tonumber(hex:sub(5, 6), 16),
  }
end

--- Ensure rgb color
---@param color number|string|{r:number, g:number, b:number}
---@return {r:number, g:number, b:number}
function M.normalize_rgb(color)
  if type(color) == "table" then
    return color
  elseif type(color) == "number" then
    return M.hex2rgb(M.dec2hex(color))
  else
    return M.hex2rgb(color)
  end
end

-- rgb to hex
---@param rgb {r:number, g:number, b:number}
---@return string -- "#rrggbb"
function M.rgb2hex(rgb)
  assert(type(rgb) == "table", "rgb2hex: expected table")
  local r = assert(rgb.r, "rgb2hex: missing r")
  local g = assert(rgb.g, "rgb2hex: missing g")
  local b = assert(rgb.b, "rgb2hex: missing b")
  return string.format("#%02x%02x%02x", r, g, b)
end

--- Returns brightness level of color in range 0 to 1 arbitrary value it's basically an weighted average
---@param color number|string|{r:number, g:number, b:number}
---@return number
function M.get_color_brightness(color)
  local c = M.normalize_rgb(color)
  local brightness = (c.r * 2 + c.g * 3 + c.b) / 6
  return brightness / 256
end

--- Returns average of colors in range 0 to 1. Used to determine contrast level
---@param color number|string|{r:number, g:number, b:number}
---@return number
function M.get_color_avg(color)
  local c = M.normalize_rgb(color)
  return (c.r + c.g + c.b) / 3 / 256
end

--- Clamps the val between left and right
---@param val number
---@param left number
---@param right number
---@return number
function M.clamp(val, left, right)
  if val > right then
    return right
  end
  if val < left then
    return left
  end
  return val
end

-- Changes brightness of rgb_color by percentage
---@param color number|string|{r:number, g:number, b:number}
---@param percentage number
---@return string
function M.brightness_modifier(color, percentage)
  local c = M.normalize_rgb(color)
  c.r = M.clamp(c.r + (c.r * percentage / 100), 0, 255)
  c.g = M.clamp(c.g + (c.g * percentage / 100), 0, 255)
  c.b = M.clamp(c.b + (c.b * percentage / 100), 0, 255)
  return M.rgb2hex(c)
end

--- Get color from hl group
---@param config (string[]|string)[] {{<name>, <scope>}}
---@param default number|string|nil
---@return number|string|nil
function M.get_hl_color(config, default)
  for _, hl in ipairs(config) do
    local name = type(hl) == "table" and hl[1] or hl ---@cast name string
    local scope = type(hl) == "table" and hl[2] or "fg"
    return M.normalize_fg_or_bg(scope, name, default)
  end
  return default
end

--- Get terminal color
---@param num number
---@param default string?
---@return string?
function M.get_term_color(num, default)
  default = default or "#000000"
  local term_color = vim.g["terminal_color_" .. tostring(num)]
  if term_color then
    return term_color
  end
  return default
end

---Wrap a string with a hl
---@param str? string content to wrap
---@param hl? string name of the highlight group
---@param restore? boolean restore highlight after the content, default true
---@return string sign string representation of the content with highlight
function M.make_hl_str(str, hl, restore)
  hl = hl or ""
  str = str or ""
  restore = restore == nil or restore
  return restore and table.concat({ "%#", hl, "#", str, "%*" })
    or table.concat({ "%#", hl, "#", str })
end

return M
