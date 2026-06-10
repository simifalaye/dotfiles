local utils = require("utils")

local function is_empty(s)
  return s == nil or s == ""
end

--
-- Parts
--

local function mode()
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
  local mode_colors = {
    n       = "UserSLModeColorNormal",
    i       = "UserSLModeColorInsert",
    v       = "UserSLModeColorVisual",
    V       = "UserSLModeColorVisualLine",
    ["\22"] = "UserSLModeColorVisualBlock",
    c       = "UserSLModeColorCommand",
    R       = "UserSLModeColorReplace",
    t       = "UserSLModeColorTerminal",
  }
  -- stylua: ignore end
  local m = vim.api.nvim_get_mode().mode
  return utils.hl.make_hl_str(
    " " .. (modes[m] or "??") .. " ",
    mode_colors[m] or "UserSLModeColorDefault"
  )
end

local function file_name(bufnr, active)
  active = active == nil or active
  local name = vim.api.nvim_buf_get_name(bufnr)
  if is_empty(name) then
    return "[No Name]"
  end
  return utils.hl.make_hl_str(
    vim.fn.fnamemodify(name, ":~:."),
    active and "UserSLTitle" or "UserSLInactiveMeta"
  )
end

local function filetype(bufnr)
  local ft = vim.bo[bufnr].filetype
  return is_empty(ft) and "text" or ft
end

local function modified_tag(bufnr, active)
  active = active == nil or active
  return utils.hl.make_hl_str(
    vim.bo[bufnr].modified and "*" or "",
    active and "UserSLDiagWarn" or "UserSLInactiveMeta"
  )
end

local function diag_summary(bufnr)
  local icons = require("static.icons")
  if not vim.diagnostic then
    return ""
  end
  local sev = vim.diagnostic.severity
  local e = #vim.diagnostic.get(bufnr, { severity = sev.ERROR })
  local w = #vim.diagnostic.get(bufnr, { severity = sev.WARN })
  local i = #vim.diagnostic.get(bufnr, { severity = sev.INFO })
  local h = #vim.diagnostic.get(bufnr, { severity = sev.HINT })

  local parts = {}
  if e > 0 then
    parts[#parts + 1] =
      utils.hl.make_hl_str((icons.Font.Diag.Error .. " %d"):format(e), "UserSLDiagError")
  end
  if w > 0 then
    parts[#parts + 1] =
      utils.hl.make_hl_str((icons.Font.Diag.Warn .. " %d"):format(w), "UserSLDiagWarn")
  end
  if i > 0 then
    parts[#parts + 1] =
      utils.hl.make_hl_str((icons.Font.Diag.Info .. " %d"):format(i), "UserSLDiagInfo")
  end
  if h > 0 then
    parts[#parts + 1] =
      utils.hl.make_hl_str((icons.Font.Diag.Hint .. " %d"):format(h), "UserSLDiagHint")
  end
  local summary = table.concat(parts, " ")
  return is_empty(summary) and "" or " " .. summary .. " "
end

local function git_branch(work_tree, git_dir)
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local b = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
    or utils.git.execute(0, {
      "--git-dir",
      git_dir,
      "--work-tree",
      work_tree,
      "rev-parse",
      "--abbrev-ref",
      "HEAD",
    })
  if not is_empty(b) then
    return b
  end
  return ""
end

local function git_diff_lines(work_tree, git_dir)
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local diff = vim.b.gitsigns_status_dict
    or utils.git.diffstat(nil, { "--git-dir", git_dir, "--work-tree", work_tree })
    or {}
  local added = diff.added or 0
  local changed = diff.changed or 0
  local removed = diff.removed or 0
  return { a = added, c = changed, r = removed }
end

local function git_info(bufnr, active)
  active = active == nil or active
  local path = vim.api.nvim_buf_get_name(bufnr)
  if is_empty(path) then
    return "", { a = 0, c = 0, r = 0 }
  end

  local work_tree, git_dir = utils.git.resolve_context(0, { {} })
  if not work_tree or not git_dir then
    return "", { a = 0, c = 0, r = 0 }
  end

  local branch = git_branch(work_tree, git_dir)
  local diff = active and git_diff_lines(work_tree, git_dir) or { a = 0, c = 0, r = 0 }
  return branch, diff
end

local function git_diff_segment(diff)
  return table.concat({
    "%#UserSLGitAdd#+",
    tostring(diff.a),
    "%#UserSLGitChange#~",
    tostring(diff.c),
    "%#UserSLGitDelete#-",
    tostring(diff.r),
    "%#UserSLMeta#",
  })
end

--
-- Statusline
--

local function position_block(active)
  active = active == nil or active
  return utils.hl.make_hl_str("%l:%c", active and "UserSLPos" or "UserSLInactiveMeta")
end

local function meta_parens(ft, branch, diff, active)
  active = active == nil or active
  local parts = { ft }

  if not is_empty(branch) then
    parts[#parts + 1] = ", " .. branch
  end

  local has_diff = (diff.a or 0) > 0 or (diff.c or 0) > 0 or (diff.r or 0) > 0
  if has_diff then
    parts[#parts + 1] = ", "
    parts[#parts + 1] = git_diff_segment(diff)
  end

  return utils.hl.make_hl_str(
    "(" .. table.concat(parts, "") .. ")",
    active and "UserSLMeta" or "UserSLInactiveMeta"
  )
end

local function active_statusline(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local ft = filetype(bufnr)
  ft = ft:sub(1, 1):upper() .. ft:sub(2)
  local branch, diff = git_info(bufnr)

  local left = table.concat({
    mode(),
    utils.hl.make_hl_str("", "UserSLBar", false),
    " ",
    "%<",
    file_name(bufnr),
    modified_tag(bufnr),
    " ",
    meta_parens(ft, branch, diff),
    " ",
  })

  local right = table.concat({
    "%=",
    diag_summary(bufnr),
    position_block(),
    " ",
  })

  return left .. right
end

local function inactive_statusline(winid)
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local ft = filetype(bufnr)
  local branch, diff = git_info(bufnr, false)

  return table.concat({
    utils.hl.make_hl_str("", "UserSLInactive", false),
    "%<",
    file_name(bufnr, false),
    modified_tag(bufnr, false),
    " ",
    meta_parens(ft, branch, diff, false),
    "%=",
    position_block(false),
    " ",
  })
end

_G.UserStatusline = function()
  local winid = tonumber(vim.g.statusline_winid) or 0
  if winid ~= 0 and winid == vim.api.nvim_get_current_win() then
    return active_statusline(winid)
  end
  return inactive_statusline(winid)
end

--
-- Highlights
--

local function set_hls()
  local c = {
    fore = utils.hl.get_hl_color({ "StatusLine", "Normal" }, "#ffffff"),
    back1 = utils.hl.get_hl_color(
      { { "StatusLine", "bg" }, { "Normal", "bg" } },
      "#000000"
    ),
    back2 = utils.hl.get_hl_color(
      { { "StatusLine", "bg" }, { "Normal", "bg" } },
      "#808080"
    ),
    primary = utils.hl.get_hl_color({ "Normal" }, "#ffffff"),
    accent1 = utils.hl.get_hl_color({ "String", "Character" }, "#ffffff"),
    accent2 = utils.hl.get_hl_color({ "Constant", "Number", "Boolean" }, "#ffffff"),
    accent3 = utils.hl.get_hl_color({ "Keyword", "Statement", "Conditional" }, "#ffffff"),
    accent4 = utils.hl.get_hl_color({ "Include", "Define", "Macro" }, "#ffffff"),
    accent5 = utils.hl.get_hl_color({ "Type", "Structure", "StorageClass" }, "#ffffff"),
    diag_warn = utils.hl.get_hl_color({ "DiagnosticWarn" }, "#d7d700"),
    diag_error = utils.hl.get_hl_color({ "DiagnosticError" }, "#d70000"),
    diag_hint = utils.hl.get_hl_color({ "DiagnosticHint" }, "#00d7d7"),
    diag_info = utils.hl.get_hl_color({ "DiagnosticInfo" }, "#0000d7"),
    git_del = utils.hl.get_hl_color({ "diffDelete" }, "#d70000"),
    git_add = utils.hl.get_hl_color({ "diffAdded" }, "#5fd700"),
    git_change = utils.hl.get_hl_color({ "diffChanged" }, "#d700d7"),
    directory = utils.hl.get_hl_color({ "Directory" }, "#0000d7"),
  }

  vim.api.nvim_set_hl(0, "UserSLBar", { fg = c.fore, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLTitle", { fg = c.fore, bg = c.back1, bold = true })
  vim.api.nvim_set_hl(0, "UserSLMeta", { fg = c.fore, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLPos", { fg = c.fore, bg = c.back1 })

  vim.api.nvim_set_hl(0, "UserSLGitAdd", { fg = c.git_add, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLGitChange", { fg = c.git_change, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLGitDelete", { fg = c.git_delete, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLInactive", { fg = c.fore, bg = c.back2 })
  vim.api.nvim_set_hl(0, "UserSLInactiveMeta", { fg = c.fore, bg = c.back2 })

  local function set_mode_hl(name, mode_color)
    local m_b = utils.hl.get_color_brightness(mode_color)
    local f_b = utils.hl.get_color_brightness(c.fore)
    local b_b = utils.hl.get_color_brightness(c.back1)
    local f_color = m_b >= 0.5 and (f_b <= b_b and c.fore or c.back1)
      or (f_b >= b_b and c.fore or c.back1)
    vim.api.nvim_set_hl(0, name, { fg = f_color, bg = mode_color })
  end
  set_mode_hl("UserSLModeColorNormal", c.primary)
  set_mode_hl("UserSLModeColorInsert", c.accent1)
  set_mode_hl("UserSLModeColorVisual", c.accent2)
  set_mode_hl("UserSLModeColorVisualLine", c.accent2)
  set_mode_hl("UserSLModeColorVisualBlock", c.accent2)
  set_mode_hl("UserSLModeColorCommand", c.accent3)
  set_mode_hl("UserSLModeColorReplace", c.accent4)
  set_mode_hl("UserSLModeColorTerminal", c.accent5)
  set_mode_hl("UserSLModeColorDefault", c.primary)

  vim.api.nvim_set_hl(0, "UserSLDiagError", { fg = c.diag_error, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLDiagWarn", { fg = c.diag_warn, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLDiagInfo", { fg = c.diag_info, bg = c.back1 })
  vim.api.nvim_set_hl(0, "UserSLDiagHint", { fg = c.diag_hint, bg = c.back1 })
end

--
-- Main
--

set_hls()
local grp = vim.api.nvim_create_augroup("user.statusline", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Refresh statusline colors on colorscheme change",
  group = grp,
  callback = function()
    set_hls()
  end,
})

vim.o.statusline = "%!v:lua.UserStatusline()"
