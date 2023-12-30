local reqcall = require("utils.reqcall")
local oil = reqcall("oil") ---@module 'oil'
local fs = require("utils.fs")

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

return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      {
        "-",
        "<cmd>Oil<CR>",
        desc = "Open parent directory",
      },
      {
        "_",
        function()
          vim.cmd("Oil " .. fs.proj_dir())
        end,
        desc = "Open root directory",
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
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
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        -- Custom
        ["Q"] = "q",
        ["q"] = "actions.close",
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
            dir = fs.remove_slash(dir)
            local entry_path = fs.join_paths(dir, entry.name)
            vim.fn.setreg('"', entry_path)
            vim.fn.setreg(vim.v.register, entry_path)
            vim.notify(
              string.format(
                "[oil] yanked '%s' to register '%s'",
                entry_path,
                vim.v.register
              )
            )
          end,
        },
        ["<C-o>"] = { -- Prevent jumping to file buffers by accident
          mode = "n",
          expr = true,
          buffer = true,
          desc = "Jump to older cursor position in oil buffer",
          callback = function()
            local jumplist = vim.fn.getjumplist()
            local prevloc = jumplist[1][jumplist[2]]
            return prevloc
                and vim.api.nvim_buf_is_valid(prevloc.bufnr)
                and vim.bo[prevloc.bufnr].ft == "oil"
                and "<C-o>"
              or "<Ignore>"
          end,
        },
        ["<C-i>"] = {
          mode = "n",
          expr = true,
          buffer = true,
          desc = "Jump to newer cursor position in oil buffer",
          callback = function()
            local jumplist = vim.fn.getjumplist()
            local newloc = jumplist[1][jumplist[2] + 2]
            return newloc
                and vim.api.nvim_buf_is_valid(newloc.bufnr)
                and vim.bo[newloc.bufnr].ft == "oil"
                and "<C-i>"
              or "<Ignore>"
          end,
        },
      },
    },
    config = function(_, opts)
      -- Setup auto change cwd autocommands
      require("utils.augroup")("user_oil_sync_cwd", {
        {
          event = { "BufEnter", "TextChanged" },
          desc = "Set cwd to follow directory shown in oil buffers.",
          pattern = "oil:///*",
          command = function(info)
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
        },
        {
          event = "DirChanged",
          desc = "Let oil buffers follow cwd.",
          command = function(info)
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
        },
      })

      ---Set some default hlgroups for oil
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

      -- Setup plugin
      oil.setup(opts)
    end,
  },
}
