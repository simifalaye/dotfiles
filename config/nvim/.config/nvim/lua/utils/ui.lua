local utils = require("utils")

local M = {}

--- Notify of a ui change
---@param str string message to print
M.ui_notify = function(str)
  if vim.g.user_notifications_enabled then
    require("utils").notify(str)
  end
end

--- Toggle notifications for UI toggles
M.toggle_notifications = function()
  vim.g.user_notifications_enabled = not vim.g.user_notifications_enabled
  M.ui_notify(
    string.format("ui notifications %s", utils.bool2str(vim.g.user_notifications_enabled))
  )
end

--- Toggle showtabline=1|0
M.toggle_tabline = function()
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 1 or 0
  M.ui_notify(string.format("tabline %s", utils.bool2str(vim.opt.showtabline:get() == 2)))
end

--- Toggle conceal=2|0
M.toggle_conceal = function()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0
  M.ui_notify(
    string.format("conceal %s", utils.bool2str(vim.opt.conceallevel:get() == 2))
  )
end

--- Toggle laststatus=3|2|0
M.toggle_statusline = function()
  local laststatus = vim.opt.laststatus:get()
  local status
  if laststatus == 0 then
    vim.opt.laststatus = 2
    status = "local"
  elseif laststatus == 2 then
    vim.opt.laststatus = 3
    status = "global"
  elseif laststatus == 3 then
    vim.opt.laststatus = 0
    status = "off"
  end
  M.ui_notify(string.format("statusline %s", status))
end

--- Toggle signcolumn="auto"|"no"
M.toggle_signcolumn = function()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  M.ui_notify(string.format("signcolumn=%s", vim.wo.signcolumn))
end

--- Set the indent and tab related numbers
M.set_indent = function()
  vim.ui.input(
    { prompt = "Set indent value (>0 expandtab, <=0 noexpandtab): " },
    function(input)
      local indent = tonumber(input)
      if not indent or indent == 0 then
        return
      end
      vim.bo.expandtab = (indent > 0) -- local to buffer
      indent = math.abs(indent)
      vim.bo.tabstop = indent -- local to buffer
      vim.bo.softtabstop = indent -- local to buffer
      vim.bo.shiftwidth = indent -- local to buffer
      M.ui_notify(
        string.format(
          "indent=%d %s",
          indent,
          vim.bo.expandtab and "expandtab" or "noexpandtab"
        )
      )
    end
  )
end

--- Change the number display modes
M.change_number = function()
  local number = vim.wo.number -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  M.ui_notify(
    string.format(
      "number %s, relativenumber %s",
      utils.bool2str(vim.wo.number),
      utils.bool2str(vim.wo.relativenumber)
    )
  )
end

--- Toggle spell
M.toggle_spell = function()
  vim.wo.spell = not vim.wo.spell -- local to window
  M.ui_notify(string.format("spell %s", utils.bool2str(vim.wo.spell)))
end

--- Toggle paste
M.toggle_paste = function()
  vim.opt.paste = vim.opt.paste:get() and vim.opt.paste:get() or false -- local to window
  M.ui_notify(string.format("paste %s", utils.bool2str(vim.opt.paste)))
end

--- Toggle wrap
M.toggle_wrap = function()
  vim.wo.wrap = not vim.wo.wrap -- local to window
  M.ui_notify(string.format("wrap %s", utils.bool2str(vim.wo.wrap)))
end

--- Toggle diagnostics
M.toggle_diagnostics = function()
  vim.g.user_diagnostics_mode = (vim.g.user_diagnostics_mode - 1) % 4
  vim.diagnostic.config(require("utils.lsp").diagnostics[vim.g.user_diagnostics_mode])
  if vim.g.user_diagnostics_mode == 0 then
    M.ui_notify("diagnostics off")
  elseif vim.g.user_diagnostics_mode == 1 then
    M.ui_notify("only status diagnostics")
  elseif vim.g.user_diagnostics_mode == 2 then
    M.ui_notify("virtual text off")
  else
    M.ui_notify("all diagnostics on")
  end
end

--- Toggle codelens
M.toggle_codelens = function()
  vim.g.user_codelens_enabled = not vim.g.user_codelens_enabled
  if not vim.g.user_codelens_enabled then
    vim.lsp.codelens.clear()
  end
  M.ui_notify(string.format("CodeLens %s", utils.bool2str(vim.g.user_codelens_enabled)))
end

--- Toggle foldcolumn=0|1
local last_active_foldcolumn
M.toggle_foldcolumn = function()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then
    last_active_foldcolumn = curr_foldcolumn
  end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  M.ui_notify(string.format("foldcolumn=%s", vim.wo.foldcolumn))
end

--- Toggle buffer semantic token highlighting for all language servers that support it
--@param bufnr? number the buffer to toggle the clients on
M.toggle_buffer_semantic_tokens = function(bufnr)
  vim.b.user_semantic_tokens_enabled = not vim.b.user_semantic_tokens_enabled
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b.user_semantic_tokens_enabled and "start" or "stop"](
        bufnr or 0,
        client.id
      )
      M.ui_notify(
        string.format(
          "Buffer lsp semantic highlighting %s",
          utils.bool2str(vim.b.user_semantic_tokens_enabled)
        )
      )
    end
  end
end

return M
