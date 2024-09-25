local permission_hlgroups = setmetatable({
  ["-"] = "OilPermissionNone",
  ["r"] = "OilPermissionRead",
  ["w"] = "OilPermissionWrite",
  ["x"] = "OilPermissionExecute",
}, {
  __index = function()
    return "OilDir"
  end,
})

local type_hlgroups = setmetatable({
  ["-"] = "OilTypeFile",
  ["d"] = "OilTypeDir",
  ["p"] = "OilTypeFifo",
  ["l"] = "OilTypeLink",
  ["s"] = "OilTypeSocket",
}, {
  __index = function()
    return "OilTypeFile"
  end,
})

-- Load plugin
local oil = require("oil")
oil.setup({
  default_file_explorer = true,
  columns = {
    {
      "type",
      icons = {
        directory = "d",
        fifo = "p",
        file = "-",
        link = "l",
        socket = "s",
      },
      highlight = function(type_str)
        return type_hlgroups[type_str]
      end,
    },
    {
      "permissions",
      highlight = function(permission_str)
        local hls = {}
        for i = 1, #permission_str do
          local char = permission_str:sub(i, i)
          table.insert(hls, { permission_hlgroups[char], i - 1, i })
        end
        return hls
      end,
    },
    { "size", highlight = "Special" },
    { "mtime", highlight = "Number" },
    {
      "icon",
      -- default_file = icon_file,
      -- directory = icon_dir,
      add_padding = false,
    },
  },
  win_options = {
    number = false,
    relativenumber = false,
    signcolumn = "no",
    foldcolumn = "0",
    statuscolumn = "",
  },
  cleanup_delay_ms = 0,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name)
      return name == ".."
    end,
  },
  use_default_keymaps = true,
  keymaps = {
    -- ["g?"] = "actions.show_help",
    -- ["<CR>"] = "actions.select",
    -- ["<C-p>"] = "actions.preview",
    -- ["<C-c>"] = "actions.close",
    -- ["<C-l>"] = "actions.refresh",
    -- ["_"] = "actions.open_cwd",
    -- ["`"] = "actions.cd",
    -- ["~"] = "actions.tcd",
    -- ["gs"] = "actions.change_sort",
    -- ["gx"] = "actions.open_external",
    -- ["g."] = "actions.toggle_hidden",
    -- ["g\\"] = "actions.toggle_trash",
    -- -- Custom
    -- ["Q"] = "q",
    -- ["q"] = "actions.close",
    -- ["l"] = "actions.select",
    -- ["h"] = "actions.parent",
    ["gy"] = {
      mode = "n",
      buffer = true,
      desc = "Yank the filepath of the entry under the cursor to a register",
      callback = function()
        local entry = oil.get_cursor_entry()
        local dir = oil.get_current_dir()
        if not entry or not dir then
          return
        end
        dir = require("utils.fs").remove_slash(dir)
        local entry_path = vim.fs.joinpath(dir, entry.name)
        vim.fn.setreg('"', entry_path)
        vim.fn.setreg(vim.v.register, entry_path)
        vim.notify(
          string.format("[oil] yanked '%s' to register '%s'", entry_path, vim.v.register)
        )
      end,
    },
  },
})

---Set some default hlgroups for oil
local function oil_sethl()
  local sethl = require("utils.hl").set
  sethl(0, "OilDir", { fg = "Directory" })
  sethl(0, "OilDirIcon", { fg = "Directory" })
  sethl(0, "OilLink", { fg = "Constant" })
  sethl(0, "OilLinkTarget", { fg = "Comment" })
  sethl(0, "OilCopy", { fg = "DiagnosticSignHint", bold = true })
  sethl(0, "OilMove", { fg = "DiagnosticSignWarn", bold = true })
  sethl(0, "OilChange", { fg = "DiagnosticSignWarn", bold = true })
  sethl(0, "OilCreate", { fg = "DiagnosticSignInfo", bold = true })
  sethl(0, "OilDelete", { fg = "DiagnosticSignError", bold = true })
  sethl(0, "OilPermissionNone", { fg = "NonText" })
  sethl(0, "OilPermissionRead", { fg = "DiagnosticSignWarn" })
  sethl(0, "OilPermissionWrite", { fg = "DiagnosticSignError" })
  sethl(0, "OilPermissionExecute", { fg = "DiagnosticSignOk" })
  sethl(0, "OilTypeDir", { fg = "Directory" })
  sethl(0, "OilTypeFifo", { fg = "Special" })
  sethl(0, "OilTypeFile", { fg = "NonText" })
  sethl(0, "OilTypeLink", { fg = "Constant" })
  sethl(0, "OilTypeSocket", { fg = "OilSocket" })
end
oil_sethl()

-- Setup autocommands
local grp_id = vim.api.nvim_create_augroup("user_oil_utilities", {})
vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged" }, {
  desc = "Set cwd to follow directory shown in oil buffers.",
  group = grp_id,
  pattern = "oil:///*",
  callback = function(info)
    if not vim.g.user_rooter_enabled then
      return
    end
    if vim.bo[info.buf].filetype == "oil" then
      local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
      local oildir = vim.fs.normalize(oil.get_current_dir())
      if cwd ~= oildir and vim.loop.fs_stat(oildir) then
        local ok = pcall(vim.cmd.lcd, oildir)
        if not ok then
          vim.notify("[oil.nvim] failed to cd to " .. oildir, vim.log.levels.WARN)
        end
      end
    end
  end,
})
vim.api.nvim_create_autocmd("DirChanged", {
  desc = "Let oil buffers follow cwd.",
  group = grp_id,
  callback = function(info)
    if vim.bo[info.buf].filetype == "oil" then
      vim.defer_fn(function()
        local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
        local oildir = vim.fs.normalize(oil.get_current_dir() or "")
        if cwd ~= oildir then
          oil.open(cwd)
        end
      end, 100)
    end
  end,
})
vim.api.nvim_create_autocmd("Colorscheme", {
  desc = "Refresh hl groups for oil on colorscheme change",
  group = grp_id,
  callback = oil_sethl,
})

-- Setup keymaps
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "_", function()
  vim.cmd("Oil " .. vim.fs.root(0, require("utils.fs")))
end, { desc = "Open root directory" })
