local M = {}

M.path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"

M.root_patterns = {
  ".git/",
  ".svn/",
  ".bzr/",
  ".hg/",
  ".project/",
  ".marksman.toml",
  ".pro",
  ".sln",
  ".vcxproj",
  "Makefile",
  "makefile",
  "MAKEFILE",
  ".gitignore",
  ".editorconfig",
}

--- Check if file exists
--- @param name string
function M.file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function M.basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

function M.remove_slash(str)
  if str:sub(-1) == "/" then
    return str:sub(1, -2)
  else
    return str
  end
end

--- Join path segments based on os type
--- @vararg string
--- @return string
function M.join_paths(...)
  local result = table.concat({ ... }, M.path_sep)
  return result
end

---Compute project directory for given path.
---@param path string?
---@param patterns string[]? root patterns
---@return string? nil if not found
function M.proj_dir(path, patterns)
  if not path or path == "" then
    path = vim.fn.expand("%:p")
  end
  patterns = patterns or M.root_patterns
  ---@diagnostic disable-next-line: undefined-field
  local stat = vim.loop.fs_stat(path)
  if not stat then
    return
  end
  local dirpath = stat.type == "directory" and path or vim.fs.dirname(path)
  for _, pattern in ipairs(patterns) do
    local root = vim.fs.find(pattern, {
      path = dirpath,
      upward = true,
      type = pattern:match("/$") and "directory" or "file",
    })[1]
    if root and vim.loop.fs_stat(root) then
      local dirname = vim.fs.dirname(root)
      return dirname and vim.loop.fs_realpath(dirname) --[[@as string]]
    end
  end
end

---Read file contents
---@param path string
---@return string?
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content or ""
end

---Write string into file
---@param path string
---@return boolean success
function M.write_file(path, str)
  local file = io.open(path, "w")
  if not file then
    return false
  end
  file:write(str)
  file:close()
  return true
end

return M
