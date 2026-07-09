--
-- Project Manager using resession.nvim
--

if vim.g.loaded_user_plugin_projects then
  return
end
vim.g.loaded_user_plugin_projects = true

---@class ProjectsOpts
---@field dir? string

---@type ProjectsOpts
local default_config = {
  dir = "projects",
}

---@type ProjectsOpts | fun():ProjectsOpts
vim.g.projects = vim.g.projects

--- Get configuration
---@return ProjectsOpts
local function get_config()
  local opts = type(vim.g.projects) == "function" and vim.g.projects()
    or vim.g.projects
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

--- Check if a project exists
---@param path string Project path
---@return boolean True if project exists
local function project_exists(path)
  return vim.tbl_contains(
    require("resession").list({ dir = get_config().dir }),
    path_to_session_name(path)
  )
end

--- Clear all buffers, tabs, and windows for a fresh project
--- Preserves terminal buffers and creates a new empty buffer
local function clear_project()
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

--- Get the current project path
---@return string|nil Current project path or nil
function M.current()
  local current = require("resession").get_current()
  return current and session_name_to_path(current) or nil
end

--- Check if a project exists
---@param path string Directory path
---@return boolean True if project exists
function M.exists(path)
  return project_exists(normalize_path(path))
end

--- List all projects
---@return table List of project paths
function M.list()
  local projects = require("resession").list({ dir = get_config().dir })
  return vim.tbl_map(function(ws)
    return session_name_to_path(ws)
  end, projects)
end

--- Switch to a project (creates it if it doesn't exist)
---@param path string Directory path
---@return boolean Success or failure
function M.switch(path)
  local resession = require("resession")
  path = normalize_path(path)

  if not vim.fn.isdirectory(path) then
    vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  local current = M.current()

  -- Don't switch to current project
  if path == current then
    return true
  end

  -- Save and detach from current project if one is attached
  if current then
    local ok, err = pcall(resession.save, current, {
      dir = get_config().dir,
      notify = false,
    })
    if not ok then
      vim.notify("Failed to save project: " .. err, vim.log.levels.ERROR)
      return false
    end
    resession.detach()
  end

  -- Remember old directory in case of failure
  local old_dir = vim.fn.getcwd()
  vim.fn.chdir(path)

  -- Load existing project or create new one
  if project_exists(path) then
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

      vim.notify("Failed to load project: " .. err, vim.log.levels.ERROR)
      return false
    end
  else
    -- Create new project from clean state
    clear_project()
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

      vim.notify("Failed to create project: " .. err, vim.log.levels.ERROR)
      return false
    end
  end

  vim.notify("Project: " .. path, vim.log.levels.INFO)
  return true
end

--- Switch to project interactively
function M.switch_interactive()
  local projects = M.list()
  local current = M.current()

  if #projects == 0 then
    vim.notify("No projects available", vim.log.levels.INFO)
    return
  end
  projects = vim.tbl_filter(function(ws)
    return ws ~= current
  end, projects)
  if #projects == 0 then
    vim.notify("No other projects available. Current: " .. current, vim.log.levels.INFO)
    return
  end

  vim.ui.select(projects, {
    prompt = "Select project: ",
  }, function(choice)
    if choice then
      M.switch(choice)
    end
  end)
end

--- Switch to the current working directory as a project
---@return boolean Success or failure
function M.switch_cwd()
  return M.switch(vim.fn.getcwd())
end

--- Add a directory as a project
---@param path string Directory path
---@return boolean Success or failure
function M.add(path)
  path = normalize_path(path)

  if not vim.fn.isdirectory(path) then
    vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  if M.exists(path) then
    vim.notify("Project already exists: " .. path, vim.log.levels.WARN)
    return false
  end

  -- Switch to the project to create it
  return M.switch(path)
end

--- Add a project interactively
function M.add_interactive()
  vim.ui.input({
    prompt = "Add project: ",
    default = vim.fn.getcwd(),
    completion = "dir",
  }, function(input)
    if input then
      M.add(input)
    end
  end)
end

--- Delete a project
---@param path string Project path to delete
---@return boolean Success or failure
function M.delete(path)
  path = normalize_path(path)

  if not project_exists(path) then
    vim.notify("Project does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end

  if path == M.current() then
    vim.notify("Cannot delete the current project", vim.log.levels.ERROR)
    return false
  end

  local choice = vim.fn.confirm(('Delete project "%s"?'):format(path), "&Yes\n&No")

  if choice == 1 then
    local ok, err = pcall(
      require("resession").delete,
      path_to_session_name(path),
      { dir = get_config().dir }
    )
    if not ok then
      vim.notify("Failed to delete project: " .. err, vim.log.levels.ERROR)
      return false
    end
    vim.notify("Project deleted: " .. path, vim.log.levels.INFO)
  end

  return true
end

--- Delete a project interactively
function M.delete_interactive()
  local projects = M.list()
  local current = M.current()

  if #projects == 0 then
    vim.notify("No projects available", vim.log.levels.INFO)
    return
  end
  projects = vim.tbl_filter(function(ws)
    return ws ~= current
  end, projects)
  if #projects == 0 then
    vim.notify(
      "No other projects available and can't delete current. Current: " .. current,
      vim.log.levels.INFO
    )
    return
  end

  vim.ui.select(projects, {
    prompt = "Delete project: ",
  }, function(choice)
    if choice then
      M.delete(choice)
    end
  end)
end

--- Setup user commands
function M.setup_commands()
  vim.api.nvim_create_user_command("ProjectSwitch", function(opts)
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
    desc = "Switch to a project (directory)",
  })

  vim.api.nvim_create_user_command("ProjectAdd", function(opts)
    if opts.args == "" then
      M.add_interactive()
    else
      M.add(opts.args)
    end
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Add a directory as a project",
  })

  vim.api.nvim_create_user_command("ProjectDelete", function(opts)
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
    desc = "Delete a project",
  })

  vim.api.nvim_create_user_command("ProjectShowCurrent", function()
    local current = M.current()
    vim.notify(current or "No project loaded", vim.log.levels.INFO)
  end, {
    desc = "Show the current project",
  })

  vim.api.nvim_create_user_command("ProjectList", function()
    local projects = M.list()
    if #projects == 0 then
      vim.notify("No projects", vim.log.levels.INFO)
      return
    end
    vim.notify(table.concat(projects, "\n"), vim.log.levels.INFO)
  end, {
    desc = "List projects",
  })

  vim.api.nvim_create_user_command("ProjectLast", function()
    local projects = M.list()
    if #projects <= 1 then
      vim.notify("No other projects", vim.log.levels.ERROR)
      return
    end
    M.switch(projects[1])
  end, {
    desc = "Switch to last project",
  })
end

--- Setup autocommands
function M.setup_autocommands()
  local group = vim.api.nvim_create_augroup("Project", { clear = true })

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
          vim.notify("Failed to save project: " .. err, vim.log.levels.ERROR)
        end
      end
    end,
  })

  -- Auto-load project on startup if in a project directory
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
vim.keymap.set("n", "<leader>pa", "<cmd>ProjectAdd<CR>", { desc = "Add" })
vim.keymap.set("n", "<leader>pc", "<cmd>ProjectShowCurrent<CR>", { desc = "Show" })
vim.keymap.set("n", "<leader>pd", "<cmd>ProjectDelete<CR>", { desc = "Delete" })
vim.keymap.set("n", "<leader>pl", "<cmd>ProjectList<CR>", { desc = "List" })
vim.keymap.set("n", "<leader>pp", "<cmd>ProjectLast<CR>", { desc = "Last" })
vim.keymap.set("n", "<leader>ps", "<cmd>ProjectSwitch<CR>", { desc = "Switch" })
