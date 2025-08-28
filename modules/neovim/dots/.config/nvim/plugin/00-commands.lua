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

vim.api.nvim_create_user_command(
  "Todo",
  [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]],
  {
    desc = "List todos in project",
  }
)

vim.api.nvim_create_user_command(
  "MoveWrite",
  -- source: https://superuser.com/a/540519
  [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]],
  {
    desc = "Move visual selection to a file (overwrite)",
    bang = true,
    range = true,
    complete = "file",
    nargs = 1, -- Selection
  }
)

vim.api.nvim_create_user_command(
  "MoveAppend",
  -- source: https://superuser.com/a/540519
  [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]],
  {
    desc = "Move visual selection to a file (append)",
    bang = true,
    range = true,
    complete = "file",
    nargs = 1, -- Selection
  }
)

vim.api.nvim_create_user_command("SystemOpen", function(args)
  local path = args.args and args.args or ""
  require("utils.cmd").sys_open(path)
end, {
  desc = "Open link/file (use empty path for whatever is under the cursor)",
  nargs = "?", -- {path?}
})

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
