---@class ResessionExtensionCompilerData
---@field global string?
---@field buffers table<string, string>

local M = {}

---Get the saved data for this extension
---@param opts resession.Extension.OnSaveOpts Information about the session being saved
---@return ResessionExtensionCompilerData
---@diagnostic disable-next-line: unused-local
M.on_save = function(opts)
  local data = {}

  -- Capture the global compiler if set
  if vim.g.current_compiler then
    data.global = vim.g.current_compiler
  end

  -- Scan all valid loaded buffers for local compilers
  local buf_compilers = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      local success, buf_comp = pcall(vim.api.nvim_buf_get_var, bufnr, "current_compiler")
      if success and buf_comp then
        local name = vim.api.nvim_buf_get_name(bufnr)
        -- Only track named files to avoid saving empty/scratch buffer states
        if name ~= "" then
          buf_compilers[name] = buf_comp
        end
      end
    end
  end

  -- Only append the buffers table if it contains data
  if next(buf_compilers) then
    data.buffers = buf_compilers
  end

  -- Return the data payload
  return data
end

---Restore the extension state
--- This is run before the buffers, windows, and tabs are restored
---@param data ResessionExtensionCompilerData The value returned from on_save
---@diagnostic disable-next-line: unused-local
M.on_pre_load = function(data) end

---Restore the extension state
--- This is run after the buffers, windows, and tabs are restored
---@param data ResessionExtensionCompilerData The value returned from on_save
M.on_post_load = function(data)
  -- Exit immediately if there is no compiler data to restore
  if not data then
    return
  end

  -- Restore global compiler
  if data.global then
    vim.g.current_compiler = data.global
  end

  -- Restore buffer-local compilers by matching file names
  if data.buffers then
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(bufnr) then
        local name = vim.api.nvim_buf_get_name(bufnr)
        local target_compiler = data.buffers[name]
        if target_compiler then
          vim.api.nvim_buf_set_var(bufnr, "current_compiler", target_compiler)
        end
      end
    end
  end
end

---Called when resession gets configured
---This function is optional
---@param data table The configuration data passed in the config
---@diagnostic disable-next-line: unused-local
M.config = function(data) end

return M
