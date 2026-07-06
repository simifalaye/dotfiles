--
-- Workspace Manager using resession.nvim
-- Provides Doom Emacs-style workspace management for project directories
--

if vim.g.loaded_user_plugin_workspaces then
  return
end
vim.g.loaded_user_plugin_workspaces = true

---@class WorkspacesOpts
---@field dir? string

---@type WorkspacesOpts
local default_config = {
  dir = "workspaces",
}

---@type WorkspacesOpts | fun():WorkspacesOpts
vim.g.workspaces = vim.g.workspaces

--- Get configuration
---@return WorkspacesOpts
local function get_config()
  local opts = type(vim.g.workspaces) == "function" and vim.g.workspaces()
    or vim.g.workspaces
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- Functions
--

local M = {}

--- Normalize a path to an absolute, canonical form
---@param path string Directory path
---@return string Normalized path
local function normalize_path(path)
  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

--- Convert a path to a resession-compatible session name
---@param path string Directory path
---@return string Session name
local function path_to_session_name(path)
  local sep = require("utils.fs").path_sep
  path = normalize_path(path)
  local str, _ = path:gsub(sep, "_"):gsub(":", "_")
  return str
end

--- Convert a session name back to a path
---@param name string Session name
---@return string Directory path
local function session_name_to_path(name)
  local sep = require("utils.fs").path_sep
  local path = name:gsub("_", sep)
  -- Handle drive letters on Windows (e.g., "C_Users" -> "C:\Users")
  if vim.fn.has("win32") == 1 then
    path = path:gsub("^([A-Za-z])" .. sep, "%1:" .. sep)
  end
  return path
end

--- Check if a workspace exists
---@param path string Workspace path
---@return boolean True if workspace exists
local function workspace_exists(path)
  return vim.tbl_contains(
    require("resession").list({ dir = get_config().dir }),
    path_to_session_name(path)
  )
end

--- Clear all buffers, tabs, and windows for a fresh workspace
--- Preserves terminal buffers and creates a new empty buffer
local function clear_workspace()
  vim.cmd("tabonly")
  vim.cmd("only")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      buf ~= vim.api.nvim_get_current_buf()
      and vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buftype ~= "terminal"
    then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end

--- Get the current workspace path
---@return string|nil Current workspace path or nil
function M.current()
  local current = require("resession").get_current()
  return current and session_name_to_path(current) or nil
end

--- Check if a workspace exists
---@param path string Directory path
---@return boolean True if workspace exists
function M.exists(path)
  dd(path)
  return workspace_exists(normalize_path(path))
end

--- List all workspaces
---@return table List of workspace paths
function M.list()
  local workspaces = require("resession").list({ dir = get_config().dir })
  return vim.tbl_map(function(ws)
    return session_name_to_path(ws)
  end, workspaces)
end

--- Switch to a workspace (creates it if it doesn't exist)
---@param path string Directory path
---@return boolean Success or failure
function M.switch(path)
  local resession = require("resession")
  path = normalize_path(path)

  if not vim.fn.isdirectory(path) then
    vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  -- Don't switch to current workspace
  if path == M.current() then
    return true
  end

  -- Save and detach from current workspace if one is attached
  local current = M.current()
  if current then
    local ok, err = pcall(resession.save, current, {
      dir = get_config().dir,
      notify = false,
    })
    if not ok then
      vim.notify("Failed to save workspace: " .. err, vim.log.levels.ERROR)
      return false
    end
    resession.detach()
  end

  -- Remember old directory in case of failure
  local old_dir = vim.fn.getcwd()
  vim.fn.chdir(path)

  -- Load existing workspace or create new one
  if workspace_exists(path) then
    local ok, err = pcall(resession.load, path_to_session_name(path), {
      dir = get_config().dir,
      silence_errors = true,
      reset = true,
    })
    if not ok then
      vim.fn.chdir(old_dir)
      -- Restore previous session if it exists
      if current then
        pcall(resession.load, current, {
          dir = get_config().dir,
          attach = true,
          reset = false,
        })
      end

      vim.notify("Failed to load workspace: " .. err, vim.log.levels.ERROR)
      return false
    end
  else
    -- Create new workspace from clean state
    clear_workspace()
    vim.cmd.edit(path)
    local ok, err = pcall(resession.save, path_to_session_name(path), {
      dir = get_config().dir,
      notify = false,
    })
    if not ok then
      vim.fn.chdir(old_dir)
      -- Restore previous session if it exists
      if current then
        pcall(resession.load, current, {
          dir = get_config().dir,
          attach = true,
          reset = false,
        })
      end

      vim.notify("Failed to create workspace: " .. err, vim.log.levels.ERROR)
      return false
    end
  end

  vim.notify("Workspace: " .. path, vim.log.levels.INFO)
  return true
end

--- Switch to workspace interactively
function M.switch_interactive()
  local workspaces = M.list()
  local current = M.current()

  if #workspaces == 0 then
    vim.notify("No workspaces available", vim.log.levels.INFO)
    return
  end
  workspaces = vim.tbl_filter(function(ws)
    return ws ~= current
  end, workspaces)
  if #workspaces == 0 then
    vim.notify("No other workspaces available. Current: " .. current, vim.log.levels.INFO)
    return
  end

  vim.ui.select(workspaces, {
    prompt = "Select workspace: ",
  }, function(choice)
    if choice then
      M.switch(choice)
    end
  end)
end

--- Switch to the current working directory as a workspace
---@return boolean Success or failure
function M.switch_cwd()
  return M.switch(vim.fn.getcwd())
end

--- Add a directory as a workspace
---@param path string Directory path
---@return boolean Success or failure
function M.add(path)
  path = normalize_path(path)

  if not vim.fn.isdirectory(path) then
    vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  if M.exists(path) then
    vim.notify("Workspace already exists: " .. path, vim.log.levels.WARN)
    return false
  end

  -- Switch to the workspace to create it
  return M.switch(path)
end

--- Add a workspace interactively
function M.add_interactive()
  vim.ui.input({
    prompt = "Add workspace: ",
    default = vim.fn.getcwd(),
    completion = "dir",
  }, function(input)
    if input then
      M.add(input)
    end
  end)
end

--- Delete a workspace
---@param path string Workspace path to delete
---@return boolean Success or failure
function M.delete(path)
  path = normalize_path(path)

  if not workspace_exists(path) then
    vim.notify("Workspace does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  if path == M.current() then
    vim.notify("Cannot delete the current workspace", vim.log.levels.ERROR)
    return false
  end

  local choice = vim.fn.confirm(('Delete workspace "%s"?'):format(path), "&Yes\n&No")

  if choice == 1 then
    local ok, err = pcall(
      require("resession").delete,
      path_to_session_name(path),
      { dir = get_config().dir }
    )
    if not ok then
      vim.notify("Failed to delete workspace: " .. err, vim.log.levels.ERROR)
      return false
    end
    vim.notify("Workspace deleted: " .. path, vim.log.levels.INFO)
  end

  return true
end

--- Delete a workspace interactively
function M.delete_interactive()
  local workspaces = M.list()
  local current = M.current()

  if #workspaces == 0 then
    vim.notify("No workspaces available", vim.log.levels.INFO)
    return
  end
  workspaces = vim.tbl_filter(function(ws)
    return ws ~= current
  end, workspaces)
  if #workspaces == 0 then
    vim.notify(
      "No other workspaces available and can't delete current. Current: " .. current,
      vim.log.levels.INFO
    )
    return
  end

  vim.ui.select(workspaces, {
    prompt = "Delete workspace: ",
  }, function(choice)
    if choice then
      M.delete(choice)
    end
  end)
end

--- Setup user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("WorkspaceSwitch", function(opts)
    if opts.args == "" then
      M.switch_interactive()
    else
      M.switch(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return M.list()
    end,
    desc = "Switch to a workspace (directory)",
  })

  vim.api.nvim_create_user_command("WorkspaceAdd", function(opts)
    if opts.args == "" then
      M.add_interactive()
    else
      M.add(opts.args)
    end
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Add a directory as a workspace",
  })

  vim.api.nvim_create_user_command("WorkspaceDelete", function(opts)
    if opts.args == "" then
      M.delete_interactive()
    else
      M.delete(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return M.list()
    end,
    desc = "Delete a workspace",
  })

  vim.api.nvim_create_user_command("WorkspaceCurrent", function()
    local current = M.current()
    vim.notify(current or "No workspace loaded", vim.log.levels.INFO)
  end, {
    desc = "Show the current workspace",
  })
end

--- Setup autocommands
function M.setup_autocommands()
  local group = vim.api.nvim_create_augroup("Workspace", { clear = true })

  -- Track stdin usage
  vim.api.nvim_create_autocmd("StdinReadPre", {
    group = group,
    callback = function()
      vim.g.using_stdin = true
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      local current = M.current()
      if current ~= nil then
        local ok, err = pcall(require("resession").save, current, {
          dir = get_config().dir,
          notify = false,
        })
        if not ok then
          vim.notify("Failed to save workspace: " .. err, vim.log.levels.ERROR)
        end
      end
    end,
  })

  -- Auto-load workspace on startup if in a project directory
  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
      if vim.fn.argc(-1) == 0 and not vim.g.using_stdin and M.current() == nil then
        if M.exists(vim.fn.getcwd()) then
          M.switch(vim.fn.getcwd())
        end
      end
    end,
  })
end

--
-- Main
--

M.setup_commands()
M.setup_autocommands()

-- Keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>wa", "<cmd>WorkspaceAdd<CR>", opts)
vim.keymap.set("n", "<leader>wc", "<cmd>WorkspaceCurrent<CR>", opts)
vim.keymap.set("n", "<leader>wd", "<cmd>WorkspaceDelete<CR>", opts)
vim.keymap.set("n", "<leader>ww", "<cmd>WorkspaceSwitch<CR>", opts)
