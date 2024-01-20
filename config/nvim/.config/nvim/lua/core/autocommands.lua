local api = vim.api
local timer = vim.loop.new_timer()
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local user_file_utilities_grp_id = augroup("user_file_utilities", {})
autocmd("BufWritePre", {
  desc = "Remove trailing whitespace on save",
  group = user_file_utilities_grp_id,
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local ignore = { "ruby", "perl", "markdown", "gitsendemail", "gitcommit" }
    for _, val in ipairs(ignore) do
      if string.match(ft, val) then
        return
      end
    end
    vim.cmd([[ %s/\s\+$//e ]])
  end,
})
autocmd("BufReadPost", {
  desc = "Jump to last known position and center buffer around cursor",
  group = user_file_utilities_grp_id,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "gitcommit" and vim.fn.win_gettype() ~= "popup" then
      local last_place_mark = api.nvim_buf_get_mark(0, '"')
      local line_nr = last_place_mark[1]
      local last_line = api.nvim_buf_line_count(0)

      if line_nr > 0 and line_nr <= last_line then
        api.nvim_win_set_cursor(0, last_place_mark)
      end
    end
  end,
})
autocmd("BufWritePre", {
  desc = "Set settings for large files.",
  group = user_file_utilities_grp_id,
  callback = function(info)
    vim.b["midfile"] = false
    vim.b["bigfile"] = false
    local ok, stat = pcall(vim.loop.fs_stat, info.match)
    if not ok then
      return
    end
    if stat and stat.size > 48000 then
      vim.b["midfile"] = true
      vim.api.nvim_create_autocmd("BufReadPost", {
        buffer = info.buf,
        once = true,
        callback = function()
          vim.schedule(function()
            pcall(vim.treesitter.stop, info.buf)
          end)
        end,
      })
      vim.api.nvim_create_autocmd("LspAttach", {
        buffer = info.buf,
        once = true,
        callback = function(args)
          vim.schedule(function()
            vim.lsp.buf_detach_client(info.buf, args.data.client_id)
          end)
        end,
      })
    end
    if stat and stat.size > 1024000 then
      vim.b["bigfile"] = true
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.opt_local.breakindent = false
      vim.opt_local.colorcolumn = ""
      vim.opt_local.statuscolumn = ""
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.winbar = ""
      vim.api.nvim_create_autocmd("BufReadPost", {
        buffer = info.buf,
        once = true,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
    end
  end,
})

local user_window_behaviours_grp_id = augroup("user_window_behaviours", {})
autocmd("VimResized", {
  desc = "Auto-resize splits",
  group = user_window_behaviours_grp_id,
  pattern = { "*" },
  command = "tabdo wincmd =",
})
autocmd("WinEnter", {
  desc = "Show cursorline when focused",
  group = user_window_behaviours_grp_id,
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd("WinLeave", {
  desc = "Hide cursorline when un-focused",
  group = user_window_behaviours_grp_id,
  callback = function()
    vim.wo.cursorline = false
  end,
})
autocmd({ "CursorMoved", "CursorMovedI" }, {
  desc = "Show cursorline when cursor is not moved for some time",
  group = user_window_behaviours_grp_id,
  callback = function()
    if not timer then
      return
    end
    vim.wo.cursorlineopt = "number"
    timer:start(
      1000, -- default timeout
      0,
      vim.schedule_wrap(function()
        vim.wo.cursorlineopt = "both"
      end)
    )
  end,
})

local user_yank_text_grp_id = augroup("user_yank_text", {})
autocmd({ "VimEnter", "CursorMoved" }, {
  desc = "Save cursor position whenever it moves",
  group = user_yank_text_grp_id,
  pattern = "*",
  callback = function()
    vim.g.user_cursor_pos = vim.fn.getpos(".")
  end,
})
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = user_yank_text_grp_id,
  callback = function()
    vim.highlight.on_yank({ timeout = 200, higroup = "IncSearch" })
  end,
})
autocmd("TextYankPost", {
  desc = "Restore cursor position after yank",
  group = user_yank_text_grp_id,
  pattern = "*",
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setpos(".", vim.g.user_cursor_pos)
    end
  end,
})

autocmd({ "BufWinEnter", "FileChangedShellPost" }, {
  desc = "Automatically change local current directory.",
  pattern = "*",
  callback = function(info)
    vim.schedule(function()
      if
        info.file == ""
        or not vim.api.nvim_buf_is_valid(info.buf)
        or vim.bo[info.buf].bt ~= ""
        or (vim.loop.fs_stat(info.file) or {}).type ~= "file"
      then
        return
      end
      local current_dir = vim.fn.getcwd(0)
      local target_dir = require("utils.fs").proj_dir(info.file)
        or vim.fs.dirname(info.file)
      local stat = target_dir and vim.loop.fs_stat(target_dir)
      -- Prevent unnecessary directory change, which triggers
      -- DirChanged autocmds that may update winbar unexpectedly
      if current_dir ~= target_dir and stat and stat.type == "directory" then
        vim.cmd.lcd(target_dir)
      end
    end)
  end,
})

-- Disable clipboard on WSL and manually copy to system clipboard
-- win32yank is very slow for pasting
if vim.fn.has("wsl") == 1 and vim.fn.executable("clip.exe") > 0 then
  vim.opt.clipboard = ""
  vim.g.loaded_clipboard_provider = true
  autocmd("TextYankPost", {
    desc = "Automatically yank text to wsl clipboard also",
    callback = function(_)
      vim.schedule(function()
        local reg = "0"
        for _, value in pairs(vim.opt.clipboard:get()) do
          if value == "unnamedplus" then
            reg = "+"
            break
          end
        end
        vim.fn.system("clip.exe", vim.fn.getreg(reg))
      end)
    end,
  })
end
