--
-- Project Manager using mini.sessions
--

if vim.g.loaded_user_plugin_project then
  return
end
vim.g.loaded_user_plugin_project = true

if not _G.Session then
  vim.notify(
    "session plugin MUST be installed and loaded for project plugin",
    vim.log.levels.WARN
  )
  return
end

---@class ProjectOpts

---@type ProjectOpts
local default_config = {}

---@type ProjectOpts | fun():ProjectOpts
vim.g.project = vim.g.project

--- Get configuration
---@return ProjectOpts
local function get_config()
  local opts = type(vim.g.project) == "function" and vim.g.project()
    or vim.g.project
    or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

local PROJECT_PREFIX = "project-"

--
-- Functions
--

--- Get the name of a project from a session name
---@param session_name string
---@return string
local function to_project(session_name)
  assert(
    session_name:sub(1, #PROJECT_PREFIX) == PROJECT_PREFIX,
    "Session is not a project"
  )
  return session_name:sub(#PROJECT_PREFIX + 1)
end

--- Get the session name for a project
---@param project_name string
---@return string
local function to_session(project_name)
  return PROJECT_PREFIX .. project_name
end

--- Check if session is a project
---@param session_name string
---@return boolean
local function is_project(session_name)
  return session_name:sub(1, #PROJECT_PREFIX) == PROJECT_PREFIX
end

--- Check if a project exists
---@param name string
---@return boolean True if project exists
local function project_exists(name)
  return Session.exists(to_session(name))
end

--- Get current project name
---@return string?
local function get_current_project()
  local current_session_path = vim.fs.normalize(vim.v.this_session)
  for _, session in ipairs(Session.list()) do
    if session.path == current_session_path and is_project(session.name) then
      return to_project(session.name)
    end
  end
  return nil
end

--- Get a list of projects
---@param exclude_current boolean?
---@return SessionMetadata[]
local function get_projects(exclude_current)
  exclude_current = exclude_current or false
  local current_session_name
  if exclude_current then
    local current = get_current_project()
    if current then
      current_session_name = to_session(current)
    end
  end
  local projects = {}
  for _, session in ipairs(Session.list()) do
    if is_project(session.name) and session.name ~= current_session_name then
      table.insert(
        projects,
        vim.tbl_extend("force", session, { name = to_project(session.name) })
      )
    end
  end
  return projects
end

--- Switch to a project (creates it if it doesn't exist)
---@param name string?
---@return boolean Success or failure
local function switch_project(name)
  if not name or not project_exists(name) then
    vim.notify("No project exists named: " .. name, vim.log.levels.ERROR)
    return false
  end
  local current = get_current_project()

  -- Don't switch to current project
  if name and name == current then
    return true
  end

  -- Switch
  Session.read(to_session(name))
  vim.notify("Project: " .. name)

  return true
end

--- Switch to project interactively
local function switch_project_interactive()
  local projects = get_projects(true)
  if #projects == 0 then
    vim.notify("No other projects available", vim.log.levels.INFO)
    return
  end
  vim.ui.select(projects, {
    prompt = "Select project: ",
    format_item = function(item)
      return ("%s"):format(item.name)
    end,
  }, function(choice)
    if choice then
      switch_project(choice.name)
    end
  end)
end

--- Add a directory as a project
---@param path string
---@param name string
---@return boolean Success or failure
local function add_project(path, name)
  if not vim.fn.isdirectory(path) then
    vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
    return false
  end
  if name == "" then
    vim.notify("Name cannot be empty", vim.log.levels.ERROR)
    return false
  end
  if project_exists(name) then
    vim.notify("Project already exists: " .. path, vim.log.levels.WARN)
    return false
  end

  -- Create new project from clean state
  Session.wipe_layout()
  vim.fn.chdir(path)
  vim.cmd.edit(path)

  -- Save project
  Session.write(to_session(name))

  return true
end

--- Add a project interactively
local function add_project_interactive()
  vim.ui.input({
    prompt = "Path: ",
    default = vim.fn.getcwd(),
    completion = "dir",
  }, function(path)
    if not path or path == "" then
      vim.notify("Path cannot be empty", vim.log.levels.ERROR)
      return
    end

    path = vim.fs.normalize(path)
    if not vim.fn.isdirectory(path) then
      vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
      return
    end

    vim.ui.input({
      prompt = "Name (optional): ",
      default = vim.fs.basename(path),
    }, function(name)
      if not name or name == "" then
        vim.notify("Name cannot be empty", vim.log.levels.ERROR)
        return
      end
      add_project(path, name)
    end)
  end)
end

--- Delete a project
---@param name string Project name
---@return boolean Success or failure
local function delete_project(name)
  if not project_exists(name) then
    vim.notify("Project does not exist: " .. name, vim.log.levels.ERROR)
    return false
  end

  local choice = vim.fn.confirm(('Delete project "%s"?'):format(name), "&Yes\n&No")
  if choice == 1 then
    Session.delete(to_session(name))
  end

  return true
end

--- Delete a project interactively
local function delete_project_interactive()
  local projects = get_projects()
  if #projects == 0 then
    vim.notify("No projects available", vim.log.levels.INFO)
    return
  end

  vim.ui.select(projects, {
    prompt = "Delete project: ",
    format_item = function(item)
      return ("%s"):format(item.name)
    end,
  }, function(choice)
    if choice then
      delete_project(choice.name)
    end
  end)
end

--
-- Main
--

exec_now(function()
  -- Autocommands
  -- local group = vim.api.nvim_create_augroup("user.plugin.project", { clear = true })
  -- vim.api.nvim_create_autocmd("VimEnter", {
  --   group = group,
  --   callback = function()
  --   end,
  -- })

  -- Commands
  vim.api.nvim_create_user_command("ProjectSwitch", function(opts)
    if opts.args == "" then
      switch_project_interactive()
    else
      switch_project(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_map(function(item)
        return item.name
      end, get_projects(true))
    end,
    desc = "Switch to a project (directory)",
  })
  vim.api.nvim_create_user_command("ProjectAdd", function(opts)
    local args = opts.fargs

    if #args > 2 then
      vim.notify("Expect at most 2 args: path, name")
      return
    end

    if #args == 0 then
      add_project_interactive()
      return
    end

    local path = args[1]
    if not vim.fn.isdirectory(path) then
      vim.notify("Directory does not exist: " .. path, vim.log.levels.ERROR)
      return
    end
    add_project(args[1], args[2] or vim.fs.basename(args[1]))
  end, {
    nargs = "*",
    complete = "dir",
    desc = "Add a directory as a project",
  })

  vim.api.nvim_create_user_command("ProjectDelete", function(opts)
    if opts.args == "" then
      delete_project_interactive()
    else
      delete_project(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_map(function(item)
        return item.name
      end, get_projects())
    end,
    desc = "Delete a project",
  })
  vim.api.nvim_create_user_command("ProjectCurrent", function()
    local current = get_current_project()
    vim.notify(current or "No project loaded", vim.log.levels.INFO)
  end, {
    desc = "Show the current project",
  })
  vim.api.nvim_create_user_command("ProjectLast", function()
    local projects = get_projects(true)
    if vim.tbl_count(projects) == 0 then
      vim.notify("No other projects", vim.log.levels.ERROR)
      return
    end
    local latest_time, latest_name = -1, nil
    for _, project in ipairs(projects) do
      if project.modify_time > latest_time then
        latest_time, latest_name = project.modify_time, project.name
      end
    end
    if latest_name then
      switch_project(latest_name)
    end
  end, {
    desc = "Switch to last project",
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>pa", "<cmd>ProjectAdd<CR>", { desc = "Add" })
  vim.keymap.set("n", "<leader>pc", "<cmd>ProjectCurrent<CR>", { desc = "Current" })
  vim.keymap.set("n", "<leader>pd", "<cmd>ProjectDelete<CR>", { desc = "Delete" })
  vim.keymap.set("n", "<leader>pp", "<cmd>ProjectLast<CR>", { desc = "Last" })
  vim.keymap.set("n", "<leader>ps", "<cmd>ProjectSwitch<CR>", { desc = "Switch" })
end)
