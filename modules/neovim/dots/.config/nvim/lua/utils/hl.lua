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

---Merge highlight attributes, use values from the right most hl group
---if there are conflicts
---@vararg string highlight group names
---@return vim.api.keyset.highlight: merged highlight attributes
function M.merge(...)
  -- Eliminate nil values in vararg
  local hl_names = {}
  for _, hl_name in pairs({ ... }) do
    if hl_name then
      table.insert(hl_names, hl_name)
    end
  end
  local hl_attr = vim.tbl_map(function(hl_name)
    return M.get(0, {
      name = hl_name,
      winhl_link = false,
    })
  end, hl_names)
  return vim.tbl_extend("force", unpack(hl_attr))
end

---@param attr_type 'fg'|'bg'|'ctermfg'|'ctermbg'
---@param fbg? string|integer
---@param default? integer
---@return integer|string|nil
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

---Set default highlight attributes, normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr vim.api.keyset.highlight highlight attributes
---@return nil
function M.set_default(ns_id, name, attr)
  attr.default = true
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

---Convert an integer from decimal to hexadecimal
---@param int integer
---@param n_digits integer? number of digits used for the hex code
---@return string hex
function M.dec2hex(int, n_digits)
  return string.format("%0" .. (n_digits or 6) .. "x", int)
end

--- Convert hex to decimal number
---@param hex string "#XXXXXX"
---@return number
function M.hex2dec(hex)
  -- Check if the string starts with "#" and remove it
  if string.sub(hex, 1, 1) == "#" then
    hex = string.sub(hex, 2)
  end
  return tonumber(hex, 16)
end

--- Turns #rrggbb -> { red, green, blue }
---@param hex string
---@return table{ red: string, green: string, blue: string }
function M.hex2rgb(hex)
  if hex:find("#") == 1 then
    hex = hex:sub(2, #hex)
  end
  return {
    red = tonumber(hex:sub(1, 2), 16),
    green = tonumber(hex:sub(3, 4), 16),
    blue = tonumber(hex:sub(5, 6), 16),
  }
end

--- Turns { red, green, blue } -> #rrggbb
---@param rgb table{ red: string, green: string, blue: string }
---@return string
function M.rgb2hex(rgb)
  return string.format("#%02x%02x%02x", rgb.red, rgb.green, rgb.blue)
end

--- Returns brightness level of color in range 0 to 1 arbitrary value it's basically an weighted average
---@param rgb_color string
---@return number
function M.get_color_brightness(rgb_color)
  local color = M.hex2rgb(rgb_color)
  local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
  return brightness / 256
end

--- Returns average of colors in range 0 to 1. Used to determine contrast level
---@param rgb_color string
---@return number
function M.get_color_avg(rgb_color)
  local color = M.hex2rgb(rgb_color)
  return (color.red + color.green + color.blue) / 3 / 256
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
function M.brightness_modifier(rgb_color, percentage)
  local color = M.hex2rgb(rgb_color)
  color.red = M.clamp(color.red + (color.red * percentage / 100), 0, 255)
  color.green = M.clamp(color.green + (color.green * percentage / 100), 0, 255)
  color.blue = M.clamp(color.blue + (color.blue * percentage / 100), 0, 255)
  return M.rgb2hex(color)
end

--- Get color from hl group
---@param scope 'bg'|'fg'|'sp'
---@param highlights string|string[]
---@param default string
---@return string
function M.get_hl_color(scope, highlights, default)
  ---@type string[]
  local highlights_tbl = type(highlights) == "table" and highlights or { highlights }
  for _, highlight in ipairs(highlights_tbl) do
    local val = {}
    if vim.fn.hlexists(highlight) then
      local color = M.get(0, { name = highlight })
      if color.bg ~= nil then
        val.bg = string.format("#%06x", color.bg)
      end
      if color.fg ~= nil then
        val.fg = string.format("#%06x", color.fg)
      end
      if color.sp ~= nil then
        val.sp = string.format("#%06x", color.sp)
      end
      if val[scope] then
        return val[scope]
      end
    end
  end
  return default
end

return M
