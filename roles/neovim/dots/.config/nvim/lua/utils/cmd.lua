local M = {}

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.run(cmd, show_error)
  local wind32_cmd
  if vim.fn.has("win32") == 1 then
    wind32_cmd = { "cmd.exe", "/C", cmd }
  end
  local result = vim.fn.system(wind32_cmd or cmd)
  local success = vim.api.nvim_get_vvar("shell_error") == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln(
      "Error running command: " .. cmd .. "\nError message:\n" .. result
    )
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

local function get_cfile_under_cursor()
  if vim.bo.filetype ~= "markdown" then
    return vim.fn.expand("<cfile>")
  end
  local WORD = vim.fn.expand("<cWORD>")
  local desc, link = string.match(WORD, "%[(.-)%]%((.-)%)")
  if desc and link then
    return link
  end
  return vim.fn.expand("<cfile>")
end

--- Open a URL or file with system
---@param path string The path to the file or URL
function M.sys_open(path)
  local is_wsl = vim.fn.has("wsl") == 1
  local open = function(p)
    local cmd
    if is_wsl and vim.fn.executable("wslview") > 0 then
      cmd = { "wslview" }
    elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") > 0 then
      cmd = { "xdg-open" }
    elseif
      (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1)
      and vim.fn.executable("open") == 1
    then
      cmd = { "open" }
    end
    if not cmd then
      M.notify("Available system opening tool not found!", vim.log.levels.ERROR)
    end
    vim.fn.jobstart(vim.fn.extend(cmd, { p }), { detach = true })
  end

  path = path ~= "" and path or get_cfile_under_cursor()
  if not path then
    return
  end

  if
    vim.fn.isdirectory(path) > 0 -- directory
    or vim.fn.filereadable(path) > 0 -- file
  then
    if is_wsl then
      path = vim.fn.system("wslpath -w " .. path)
    end
    return open(path)
  elseif path:match("http[s]?://") then -- link
    return open(path)
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = "[%a%d%-%.%_]*%/[%a%d%-%.%_]*"
  local link = string.match(path, plugin_url_regex)
  if link then
    return open(string.format("https://www.github.com/%s", link))
  end
end

return M
