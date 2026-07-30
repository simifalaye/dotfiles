vim.api.nvim_create_user_command("RenameFile", function()
  local old_name = vim.api.nvim_buf_get_name(0)

  if old_name == "" or vim.fn.filereadable(old_name) == 0 then
    vim.notify("Current buffer is not associated with a file", vim.log.levels.ERROR)
    return
  end

  vim.ui.input({ prompt = "New filename: ", default = old_name }, function(new_name)
    if new_name and new_name ~= "" and new_name ~= old_name then
      local ok, err = os.rename(old_name, new_name)
      if not ok then
        vim.notify("Rename failed: " .. err, vim.log.levels.ERROR)
        return
      end

      vim.cmd("edit " .. vim.fn.fnameescape(new_name))
      vim.cmd("bdelete! #") -- delete the old buffer
      vim.notify("Renamed to " .. new_name)
    end
  end)
end, {
  desc = "Prompt to rename current file and buffer",
})

vim.api.nvim_create_user_command("DeleteFile", function(opts)
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" or vim.fn.filereadable(file) == 0 then
    vim.notify("No file to delete", vim.log.levels.ERROR)
    return
  end

  local function delete_file()
    local ok, err = os.remove(file)
    if not ok then
      vim.notify("Failed to delete file: " .. err, vim.log.levels.ERROR)
      return
    end
    vim.cmd("bdelete!")
    vim.notify("Deleted file: " .. file)
  end

  -- If force is passed (e.g., :DeleteFile!), skip confirmation
  if opts.bang then
    delete_file()
  else
    vim.ui.input({ prompt = "Delete " .. file .. "? (y/n): " }, function(input)
      if input and input:lower() == "y" then
        delete_file()
      else
        vim.notify("Cancelled file deletion")
      end
    end)
  end
end, {
  desc = "Delete current file and close its buffer",
  bang = true, -- enables :DeleteFile!
})

vim.api.nvim_create_user_command("YankFilePath", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("No file path to yank (buffer is not a file)", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("Yanked file path to clipboard:\n" .. path)
end, { desc = "Yank full file path to system clipboard" })

vim.api.nvim_create_user_command("Cwd", function()
  vim.cmd(":cd %:p:h")
  vim.cmd(":pwd")
end, { desc = "cd current file's directory" })

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd("bel 10new")
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs({
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  }) do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer", nargs = 0 })

local function complete_pack_names(arglead)
  local items = {}
  local packs = (vim.pack and vim.pack.get) and vim.pack.get(nil, { info = false }) or {}

  for _, plug in ipairs(packs) do
    local name = tostring(plug.spec.name) ---@type string
    if arglead == "" or name:find("^" .. vim.pesc(arglead)) then
      items[#items + 1] = name
    end
  end

  table.sort(items)
  return items
end

vim.api.nvim_create_user_command("PackAdd", function(opts)
  local src = opts.fargs[1]
  local version = opts.fargs[2]

  ---@type vim.pack.Spec
  local spec = { src = src }
  if version and version ~= "" then
    spec.version = version
  end

  vim.pack.add({ spec })
end, {
  desc = "vim.pack.add wrapper: :PackAdd {src} [version]",
  nargs = "+", -- {src,version?}
  complete = "file",
})

vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs, { force = opts.bang })
end, {
  desc = "vim.pack.del wrapper: :PackDel[!] {name} ... (use ! to force)",
  bang = true,
  nargs = "+",
  complete = function(arglead, _, _)
    return complete_pack_names(arglead)
  end,
})

vim.api.nvim_create_user_command("PackGet", function(opts)
  local names = (#opts.fargs > 0) and opts.fargs or nil
  local info = not opts.bang

  local res = vim.pack.get(names, { info = info })
  vim.print(res)
end, {
  desc = "vim.pack.get wrapper: :PackGet[!] [name ...] (! => info=false)",
  bang = true,
  nargs = "*",
  complete = function(arglead, _, _)
    return complete_pack_names(arglead)
  end,
})

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local names = (#opts.fargs > 0) and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang })
end, {
  desc = "vim.pack.update wrapper: :PackUpdate[!] [name ...] (! => force)",
  bang = true,
  nargs = "*",
  complete = function(arglead, _, _)
    return complete_pack_names(arglead)
  end,
})

vim.api.nvim_create_user_command("PackClean", function()
  local plugs = vim.pack.get(nil, nil)
  local remove_list = {}
  for _, plug in ipairs(plugs) do
    if not plug.active and plug.spec then
      table.insert(remove_list, plug.spec.name)
    end
  end
  vim.pack.del(remove_list)
end, { desc = "Clean inactive plugins", nargs = 0 })


local function is_lua_active()
  -- Check filetype first as a fast escape hatch
  if vim.bo.filetype == 'lua' then
    return true
  end

  -- Safely get the native parser for the current buffer
  local buf = vim.api.nvim_get_current_buf()
  local success, parser = pcall(vim.treesitter.get_parser, buf)
  if not success or not parser then
    return false
  end

  -- Determine coordinate based on active mode
  local row, col

  -- Check if we are currently in Visual or Visual-Line mode
  if vim.api.nvim_get_mode().mode:match('^[vV]') then
    local _, start_row, start_col, _ = unpack(vim.fn.getpos('v'))
    row = start_row - 1
    col = start_col - 1
  else
    -- Unpack the table into separate row and col variables
    local cursor = vim.api.nvim_win_get_cursor(0)
    row = cursor[1] - 1
    col = cursor[2]
  end

  -- Query native Treesitter for the language tree at that specific point
  local lang_tree = parser:language_for_range({ row, col, row, col })
  if lang_tree then
    return lang_tree:lang() == 'lua'
  end

  return false
end

vim.api.nvim_create_user_command("LuaExecLine", function()
  if not is_lua_active() then
    vim.notify("Can't execute non-lua code", vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_get_current_line()
  local chunk, err = load(line)

  if not chunk then
    vim.notify(err or "Failed to execute line", vim.log.levels.ERROR)
    return
  end

  local ok, runtime_err = pcall(chunk)
  if not ok then
    vim.notify(runtime_err, vim.log.levels.ERROR)
    return
  end

  vim.notify("Executed line", vim.log.levels.INFO, { title = "LuaExec" })
end, {
  desc = "Execute the current line as Lua",
})

vim.api.nvim_create_user_command("LuaExecSelection", function(opts)
  if not is_lua_active() then
    vim.notify("Can't execute non-lua code", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  local chunk, err = load(table.concat(lines, "\n"))

  if not chunk then
    vim.notify(err or "Failed to execute selection", vim.log.levels.ERROR)
    return
  end

  local ok, runtime_err = pcall(chunk)
  if not ok then
    vim.notify(runtime_err, vim.log.levels.ERROR)
    return
  end

  vim.notify(
    ("Executed %d line%s"):format(#lines, #lines == 1 and "" or "s"),
    vim.log.levels.INFO,
    { title = "LuaExec" }
  )
end, {
  desc = "Execute the selected lines as Lua",
  range = true,
})

vim.api.nvim_create_user_command("LuaReload", function(opts)
  local module = opts.args
  package.loaded[module] = nil
  local success, err = pcall(require, module)
  if success then
    vim.notify("Successfully reloaded: " .. module, vim.log.levels.INFO)
  else
    vim.notify(
      "Error reloading " .. module .. ": " .. tostring(err),
      vim.log.levels.ERROR
    )
  end
end, { nargs = 1 })
