local function dec2hex(decimal)
  if not decimal then
    return nil
  end
  return string.format("#%X", decimal)
end

local function hex2dec(hex)
  if not hex then
    return nil
  end
  -- Check if the string starts with "#" and remove it
  if string.sub(hex, 1, 1) == "#" then
    hex = string.sub(hex, 2)
  end
  return tonumber(hex, 16)
end

local M = {}

--- Wrapper of nvim_get_hl(), but does not create a cleared highlight group
---if it doesn't exist
---NOTE: vim.api.nvim_get_hl() has a side effect, it will create a cleared
---highlight group if it doesn't exist, see
---https://github.com/neovim/neovim/issues/24583
---This affects regions highlighted by non-existing highlight groups in a
---winbar, which should falls back to the default 'WinBar' or 'WinBarNC'
---highlight groups but instead falls back to 'Normal' highlight group
---because of this side effect
---So we need to check if the highlight group exists before calling
---vim.api.nvim_get_hl()
---@param ns_id integer
---@param opts table{ name: string?, id: integer?, link: boolean? }
---@return table<string, any>: highlight attributes
function M.get(ns_id, opts)
  if not opts.name then
    return vim.api.nvim_get_hl(ns_id, opts)
  end
  return vim.fn.hlexists(opts.name) == 1 and vim.api.nvim_get_hl(ns_id, opts) or {}
end

---Wrapper of nvim_buf_add_highlight(), but does not create a cleared
---highlight group if it doesn't exist
---@param hl_group string name of the highlight group to use
---@param buffer integer buffer handle, or 0 for current buffer
---@param ns_id integer namespace to use or -1 for ungrouped highlight
---@param col_start integer start of (byte-indexed) column range to highlight
---@param col_end integer end of (byte-indexed) column range to highlight, or -1 to highlight to end of line
---@param line integer line to highlight (zero-indexed)
---@return nil
function M.buf_add_hl(buffer, ns_id, hl_group, line, col_start, col_end)
  if vim.fn.hlexists(hl_group) == 0 then
    return
  end
  vim.api.nvim_buf_add_highlight(buffer, ns_id, hl_group, line, col_start, col_end)
end

---Merge highlight attributes, use values from the right most hl group
---if there are conflicts
---@vararg string highlight group names
---@return table<string, any>: merged highlight attributes
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
      link = false,
    })
  end, hl_names)
  return vim.tbl_extend("force", unpack(hl_attr))
end

---@param attr_type 'fg'|'bg'
---@param fbg? table<string|integer>|string|integer
---@param default? string
---@return string|nil
function M.normalize_fg_or_bg(attr_type, fbg, default)
  if not fbg then
    return default
  end
  if type(fbg) ~= "table" then
    fbg = { fbg }
  end
  for _, v in ipairs(fbg) do
    local data_type = type(v)
    if data_type == "number" then
      return dec2hex(v)
    end
    if data_type == "string" then
      if vim.fn.hlexists(v) == 1 then
        return dec2hex(vim.api.nvim_get_hl(0, {
          name = v,
          link = false,
        })[attr_type])
      end
      if v:match("^#%x%x%x%x%x%x$") then
        return v
      end
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
---@param attr table<string, any> highlight attributes
---@return table: normalized highlight attributes
function M.normalize(attr)
  if attr.link then
    local num_keys = #vim.tbl_keys(attr)
    if num_keys <= 1 then
      return attr
    end
    attr.fg = M.normalize_fg_or_bg("fg", attr.fg)
    attr.bg = M.normalize_fg_or_bg("bg", attr.bg)
    attr =
      vim.tbl_extend("force", M.get(0, { name = attr.link, link = false }) or {}, attr)
    attr.link = nil
    return attr
  end
  attr.fg = M.normalize_fg_or_bg("fg", attr.fg)
  attr.bg = M.normalize_fg_or_bg("bg", attr.bg)
  return attr
end

---Wrapper of nvim_set_hl(), normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr table<string, any> highlight attributes
---@return nil
function M.set(ns_id, name, attr)
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

---Set default highlight attributes, normalize highlight attributes before setting
---@param ns_id integer namespace id
---@param name string
---@param attr table<string, any> highlight attributes
---@return nil
function M.set_default(ns_id, name, attr)
  attr.default = true
  return vim.api.nvim_set_hl(ns_id, name, M.normalize(attr))
end

return M
