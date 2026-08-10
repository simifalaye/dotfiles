--
-- Neovim global plugin for handling notes
--

if vim.g.loaded_user_plugin_notes then
  return
end
vim.g.loaded_user_plugin_notes = true

local default_notes_dir = vim.env.NOTES_DIR or vim.fs.joinpath(vim.env.HOME, "notes")

---@class NotesOpts
---@field disable? boolean
---@field dir? string
---@field script? string

---@type NotesOpts
local default_config = {
  disable = false,
  dir = default_notes_dir,
  script = vim.fs.joinpath(default_notes_dir, "scripts", "notes"),
}

---@type NotesOpts | fun():NotesOpts
vim.g.notes = vim.g.notes

--- Get configuration
---@return NotesOpts
local function get_config()
  local opts = type(vim.g.notes) == "function" and vim.g.notes() or vim.g.notes or {}
  local config = vim.tbl_deep_extend("force", default_config, opts)
  return config
end

--
-- Functions
--

local M = {}

--- Execute notes script and return output
---@param args string[] Command arguments
---@param opts? table Options table
---@return string output
local function execute_notes(args, opts)
  opts = opts or {}

  local config = get_config()
  local env = {}
  env.IN_EDITOR = 1
  env.NOTES_DIR = config.dir

  local cmd = { config.script }
  vim.list_extend(cmd, args)

  local result = vim
      .system(cmd, {
        env = env,
        text = true,
      })
      :wait()

  if result.code ~= 0 then
    vim.notify(
      "Error running notes command: " .. (result.stderr or table.concat(args, " ")),
      vim.log.levels.ERROR
    )
    return ""
  end

  return result.stdout or ""
end

--- Get lines from command output
---@param output string Command output
---@return string[] lines
local function get_lines(output)
  local lines = {}
  for line in (output .. "\n"):gmatch("(.-)\n") do
    table.insert(lines, line)
  end
  return lines
end

--- Open file in buffer
---@param filepath string Path to file
local function open_file(filepath)
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
end

--- Run note command and open
---@param args string[] Command arguments
---@param opts? table Options table
local function execute_and_open(args, opts)
  local output = execute_notes(args, opts)
  local filepath = output:match("^%s*(.-)%s*$")
  if filepath and filepath ~= "" then
    open_file(filepath)
  end
end

--- Notes: today
function M.today()
  execute_and_open({ "today" })
end

--- Notes: yesterday
function M.yesterday()
  execute_and_open({ "yesterday" })
end

--- Notes: tomorrow
function M.tomorrow()
  execute_and_open({ "tomorrow" })
end

function M.capture()
  local notes_dir = get_config().dir
  local tmpfile = vim.trim(vim.fn.system({
    "mktemp",
    "--suffix=.md",
    "--tmpdir=" .. notes_dir,
  }))
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
    return
  end

  local alt_buf = vim.fn.bufnr("#")
  open_file(tmpfile)
  local bufnr = vim.api.nvim_get_current_buf()

  local function delete_tmpfile()
    vim.fn.delete(tmpfile)
  end
  local function delete_tmpfile_buffer()
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    -- If we're still in the temp buffer, switch away before deleting it.
    if vim.api.nvim_get_current_buf() == bufnr then
      if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) then
        vim.api.nvim_set_current_buf(alt_buf)
      end
    end
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end

  local captured = false
  local augroup = vim.api.nvim_create_augroup("NotesCapture" .. bufnr, { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    buffer = bufnr,
    once = true,
    callback = function()
      if captured then
        return
      end
      captured = true

      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      -- Save changes if necessary.
      if vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("silent write")
        end)
      end

      local ok, err = pcall(execute_notes, { "capture", tmpfile })

      delete_tmpfile()
      delete_tmpfile_buffer()

      if ok then
        vim.notify("Note captured", vim.log.levels.INFO)
      else
        vim.notify(err, vim.log.levels.ERROR)
      end
    end,
  })

  vim.api.nvim_create_autocmd({
    "BufDelete",
    "BufWipeout",
    "VimLeavePre",
  }, {
    group = augroup,
    buffer = bufnr,
    once = true,
    callback = function()
      delete_tmpfile()
      delete_tmpfile_buffer()
    end,
  })
end

function M.captures()
  local output = execute_notes({ "capture" })
  local lines = get_lines(output)

  if #lines < 2 then
    vim.notify("Error getting capture paths", vim.log.levels.ERROR)
    return
  end

  local tmpfile = lines[1]
  local marker_file = lines[2]

  -- Open the temp file
  open_file(tmpfile)

  local bufnr = vim.api.nvim_get_current_buf()
  local original_buf = nil

  -- Store the alternate buffer if it exists
  local alt_buf = vim.fn.bufnr("#")
  if alt_buf ~= -1 and vim.api.nvim_buf_is_valid(alt_buf) then
    original_buf = alt_buf
  end

  -- Create autocommand to handle save and finalization
  local augroup =
      vim.api.nvim_create_augroup("user.plugin.notes_capture", { clear = false })

  local function cleanup_and_switch()
    if vim.api.nvim_buf_is_valid(bufnr) then
      -- Switch to alternate buffer or create new empty buffer
      if original_buf and vim.api.nvim_buf_is_valid(original_buf) then
        vim.api.nvim_set_current_buf(original_buf)
      else
        vim.cmd("enew")
      end
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      -- Touch the marker file
      vim.fn.system({ "touch", marker_file })

      -- Run finalize-capture
      execute_notes({ "finalize-capture", tmpfile })

      vim.notify("Note captured", vim.log.levels.INFO)

      -- Clean up temp files
      vim.fn.system({ "rm", "-f", tmpfile, marker_file })

      cleanup_and_switch()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout" }, {
    group = augroup,
    buffer = bufnr,
    once = true,
    callback = function()
      -- Clean up temp files if they still exist
      vim.fn.system({ "rm", "-f", tmpfile, marker_file })

      if vim.api.nvim_buf_is_valid(bufnr) then
        cleanup_and_switch()
      end
    end,
  })
end

--- Notes: tags
function M.list_tags()
  local output = execute_notes({ "list-tags" })
  local tags = get_lines(output)

  if #tags == 0 then
    vim.notify("No tags found", vim.log.levels.INFO)
    return
  end
  print(table.concat(tags, "\n"))
end

--- Notes: review
---@param args string[] Optional tag arguments
function M.review(args)
  args = args or {}

  if #args == 0 then
    -- Get tags and let user select
    local output = execute_notes({ "list-tags" })
    local tags = get_lines(output)

    if #tags == 0 then
      vim.notify("No tags found", vim.log.levels.INFO)
      return
    end

    vim.ui.select(tags, {
      prompt = "Select tags to review (Tab to multi-select): ",
    }, function(choice, _)
      if choice then
        M.review({ choice })
      end
    end)
  else
    -- Execute review with provided tags
    local cmd = { "review" }
    vim.list_extend(cmd, args)

    local output = execute_notes(cmd)
    if output == "" or output:match("^No entries found") then
      vim.notify(
        "No entries found for tags: " .. table.concat(args, ", "),
        vim.log.levels.INFO
      )
      return
    end

    vim.cmd("enew")
    local lines = get_lines(output)

    -- Add modeline for markdown at the beginning
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    local bufnr = vim.api.nvim_get_current_buf()

    -- Set buffer as readonly and non-modifiable
    vim.bo.modifiable = false
    vim.bo.readonly = true
    vim.bo.filetype = "markdown"
    vim.bo.buftype = "nofile"

    -- Prevent any modifications
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertEnter" }, {
      buffer = bufnr,
      callback = function()
        if vim.bo.modifiable then
          vim.bo.modifiable = false
        end
      end,
    })

    -- Make q close the buffer
    vim.keymap.set("n", "q", ":bdelete<CR>", { buffer = bufnr, noremap = true })
  end
end

--- Notes: rename-tag
function M.rename_tag()
  local output = execute_notes({ "list-tags" })
  local tags = get_lines(output)

  if #tags == 0 then
    vim.notify("No tags found", vim.log.levels.INFO)
    return
  end

  vim.ui.select(tags, {
    prompt = "Select tag to rename: ",
  }, function(old_tag, _)
    if old_tag then
      vim.ui.input({
        prompt = "New tag name: ",
        default = old_tag,
      }, function(new_tag)
        if new_tag and new_tag ~= "" then
          local cmd = { "rename-tag", old_tag, new_tag }
          local result = execute_notes(cmd)
          vim.notify(result, vim.log.levels.INFO)
        end
      end)
    end
  end)
end

--
-- Main
--

exec_later(function()
  -- Commands
  vim.api.nvim_create_user_command("NotesToday", M.today, { desc = "Today" })
  vim.api.nvim_create_user_command("NotesYesterday", M.yesterday, { desc = "Yesterday" })
  vim.api.nvim_create_user_command("NotesTomorrow", M.tomorrow, { desc = "Tomorrow" })
  vim.api.nvim_create_user_command("NotesCapture", M.capture, { desc = "Capture" })
  vim.api.nvim_create_user_command("NotesTags", M.list_tags, { desc = "List tags" })
  vim.api.nvim_create_user_command("NotesReview", function(opts)
    M.review(opts.fargs)
  end, { desc = "Review", nargs = "*" })
  vim.api.nvim_create_user_command(
    "NotesRenameTag",
    M.rename_tag,
    { desc = "Rename tag" }
  )

  local prefix = "<leader>n"
  vim.keymap.set("n", prefix .. "t", M.today, { noremap = true, desc = "Today" })
  vim.keymap.set("n", prefix .. "y", M.yesterday, { noremap = true, desc = "Yesterday" })
  vim.keymap.set("n", prefix .. "m", M.tomorrow, { noremap = true, desc = "Tomorrow" })
  vim.keymap.set("n", prefix .. "c", M.capture, { noremap = true, desc = "Capture" })
  vim.keymap.set("n", prefix .. "l", M.list_tags, { noremap = true, desc = "List tags" })
  vim.keymap.set("n", prefix .. "r", M.review, { noremap = true, desc = "Review" })
  vim.keymap.set(
    "n",
    prefix .. "R",
    M.rename_tag,
    { noremap = true, desc = "Rename tag" }
  )
end)
