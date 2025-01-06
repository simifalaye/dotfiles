--
-- Neovim global plugin for auto-changing directory to the root of an opened buffer
--

if vim.g.loaded_user_plugin_diagnostics then
  return
end
vim.g.loaded_user_plugin_diagnostics = true

---@class DiagnosticsSignDefinition
---@field name "DiagnosticSignError"|"DiagnosticSignWarn"|"DiagnosticSignHint"|"DiagnosticSignInfo"
---@field text string

---@class DiagnosticsModeDefintion
---@field name string
---@field config vim.diagnostic.Opts

---@class DiagnosticsOpts
---@field signs? DiagnosticsSignDefinition[]
---@field modes? DiagnosticsModeDefintion[]
---@field default_mode? number
---@field hover_notification_enabled? boolean

local signs = {
  { name = "DiagnosticSignError", text = "E" },
  { name = "DiagnosticSignWarn", text = "W" },
  { name = "DiagnosticSignHint", text = "H" },
  { name = "DiagnosticSignInfo", text = "I" },
}
local default_diagnostics = {
  virtual_text = true,
  signs = { active = signs },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

---@type DiagnosticsOpts
local default_config = {
  signs = signs,
  modes = {
    {
      name = "Off",
      config = vim.tbl_deep_extend("force", default_diagnostics, {
        underline = false,
        virtual_text = false,
        signs = false,
        update_in_insert = false,
      }),
    },
    {
      name = "Status Only",
      config = vim.tbl_deep_extend(
        "force",
        default_diagnostics,
        { virtual_text = false, signs = false }
      ),
    },
    -- virtual text off, signs on
    {
      name = "Signs",
      config = vim.tbl_deep_extend(
        "force",
        default_diagnostics,
        { virtual_text = false }
      ),
    },
    -- all diagnostics on
    { name = "All", config = default_diagnostics },
  },
  default_mode = 2,
  hover_notification_enabled = true,
}

---@type DiagnosticsOpts | fun():DiagnosticsOpts
vim.g.user_diagnostics = vim.g.user_diagnostics

--- Validate config
---@param config table
---@return boolean
local function validate_config(config)
  local ok, err = pcall(vim.validate, {
    signs = { config.signs, "table" },
    modes = { config.modes, "table" },
    default_mode = { config.default_mode, "number" },
    hover_notification_enabled = { config.hover_notification_enabled, "boolean" },
  })
  if not ok then
    vim.notify("Diagnostics config: " .. err, vim.log.levels.ERROR)
    return false
  end
  for i, sign in ipairs(config.signs) do
    ok, err = pcall(vim.validate, {
      name = { sign.name, "string" },
      text = { sign.text, "string" },
    })
    if not ok then
      vim.notify(
        string.format("Diagnostics config sign[%d]: %s", i, err),
        vim.log.levels.ERROR
      )
      return false
    end
  end
  return true
end

--- Get configuration
---@return DiagnosticsOpts
local function get_config()
  local opts = type(vim.g.user_diagnostics) == "function" and vim.g.user_diagnostics()
    or vim.g.user_diagnostics
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  if not validate_config(config) then
    return default_config
  end
  return config
end

--
-- Main
--

local config = get_config()

-- Configure signs
for _, sign in ipairs(config.signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Configure Diagnostics
local current_mode = config.default_mode
vim.diagnostic.config(config.modes[current_mode].config)

-- Define sign mode command
vim.api.nvim_create_user_command("SetDiagnosticMode", function(args)
  local conf = get_config()
  local mode = tonumber(args.args)
  if not mode then
    mode = current_mode < #conf.modes and current_mode + 1 or 1
  elseif mode < 1 or mode > #conf.modes then
    vim.notify(
      "Provided mode MUST be a number between 1 and " .. #conf.modes,
      vim.log.levels.ERROR
    )
    return
  end
  -- Set diagnotics based on mode
  current_mode = mode
  vim.diagnostic.config(config.modes[current_mode].config)
  vim.notify("Diagnostic set: " .. config.modes[current_mode].name, vim.log.levels.INFO)
end, {
  desc = "Set/Toggle diagnostic mode",
  nargs = "?", -- {mode(0-3)?}
})

local diagnostics_grp = vim.api.nvim_create_augroup("user_plugin_diagnostics", {})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  group = diagnostics_grp,
  desc = "Show diagnostics on cursor hold",
  callback = function()
    local conf = get_config()
    if not conf.hover_notification_enabled then
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1], cursor_pos[2]

    -- Get the diagnostics for the current line and column
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = row - 1 })
    if not diagnostics or #diagnostics == 0 then
      return
    end

    -- Check if there are any diagnostics
    local msg = ""
    for _, diag in ipairs(diagnostics) do
      if
        diag.lnum == row - 1
        and diag.col <= col
        and (diag.end_col == nil or diag.end_col >= col)
      then
        if string.len(msg) > 0 then
          msg = msg .. "\n"
        end
        msg = msg .. diag.message
      end
    end
    if string.len(msg) > 0 then
      vim.notify("Diagnostic: " .. msg, vim.log.levels.INFO, {
        -- snacks.nvim notifier
        id = "user_diagnostics_notification",
        -- fidget.nvim
        key = "user_diagnostics_notification",
        skip_history = true,
      })
    end
  end,
})
