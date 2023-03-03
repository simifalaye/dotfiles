local M = {}

local function hl_by_name(name)
  return string.format(
    "#%06x",
    vim.api.nvim_get_hl_by_name(name.group, true)[name.prop]
  )
end

local function hl_prop(group, prop)
  local status_ok, color = pcall(hl_by_name, { group = group, prop = prop })
  return status_ok and color or nil
end

--- Get color strings (fg and bg) of a highlight group
---@param hlgroup string name of group
---@param base table?
---@return table
M.get_hl_group = function(hlgroup, base)
  return vim.tbl_deep_extend(
    "force",
    base or {},
    { fg = hl_prop(hlgroup, "foreground"), bg = hl_prop(hlgroup, "background") }
  )
end

--- Set the values of multiple highlights (fg and bg)
---@param highlights table in format {name = {fg="#<code>", bg="#<code>", ...}
M.set_highlights = function(highlights)
  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M
