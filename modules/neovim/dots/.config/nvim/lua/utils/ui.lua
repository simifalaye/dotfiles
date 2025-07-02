local M = {}

--
-- Toggles
--

function M.bool2str(bool)
  return bool and "on" or "off"
end

--- Set the indent and tab related numbers
function M.set_indent()
  local input_avail, input =
    pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then
      return
    end
    vim.bo.expandtab = (indent > 0) -- local to buffer
    indent = math.abs(indent)
    vim.bo.tabstop = indent -- local to buffer
    vim.bo.softtabstop = indent -- local to buffer
    vim.bo.shiftwidth = indent -- local to buffer
    vim.notify(
      string.format(
        "indent=%d %s",
        indent,
        vim.bo.expandtab and "expandtab" or "noexpandtab"
      )
    )
  end
end

--- Toggle codelens
--- @param bufnr? number the buffer to toggle `codelens` on.
function M.toggle_codelens(bufnr)
  bufnr = bufnr or 0

  vim.b[bufnr].user_lsp_codelens_disable = not vim.b[bufnr].user_lsp_codelens_disable
  if not vim.b[bufnr].user_lsp_codelens_disable then
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  else
    vim.lsp.codelens.clear()
  end
  vim.notify(
    string.format("CodeLens %s", M.bool2str(not vim.b[bufnr].user_lsp_codelens_disable))
  )
end

--- Toggle conceal=2|0
function M.toggle_conceal()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
  vim.notify(string.format("conceal %s", M.bool2str(vim.o.conceallevel == 2)))
end

--- Toggle diagnostics
--- @param bufnr? number the buffer to toggle diagnostics on.
function M.toggle_diagnostics(bufnr)
  local opts = { bufnr = bufnr }
  if vim.diagnostic.is_enabled(opts) then
    vim.diagnostic.enable(false, opts)
    vim.notify("diagnostics off")
  else
    vim.diagnostic.enable(true, opts)
    vim.notify("diagnostics on")
  end
end

local last_active_foldcolumn
--- Toggle foldcolumn=0|1
function M.toggle_foldcolumn()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then
    last_active_foldcolumn = curr_foldcolumn
  end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  vim.notify(string.format("foldcolumn=%s", vim.wo.foldcolumn))
end

-- Toggle LSP inlay hints
--- @param bufnr? number the buffer to toggle the `inlay hints` on.
function M.toggle_inlay_hints(bufnr)
  bufnr = bufnr or 0

  vim.b[bufnr].user_lsp_inlay_hints_disable =
    not vim.b[bufnr].user_lsp_inlay_hints_disable
  vim.lsp.inlay_hint.enable(
    not vim.b[bufnr].user_lsp_inlay_hints_disable,
    { bufnr = bufnr }
  )
  vim.notify(
    string.format(
      "Buffer inlay hints %s",
      M.bool2str(not vim.b[bufnr].user_lsp_inlay_hints_disable)
    )
  )
end

--- Toggle paste
function M.toggle_paste()
  vim.o.paste = not vim.o.paste -- local to window
  vim.notify(string.format("paste %s", M.bool2str(vim.o.paste)))
end

--- Toggle buffer semantic token highlighting for all language servers that support it
--- @param bufnr? number the buffer to toggle `semantic tokens` on.
function M.toggle_semantic_tokens(bufnr)
  bufnr = bufnr or 0

  vim.b[bufnr].user_lsp_semantic_tokens_disable =
    not vim.b[bufnr].user_lsp_semantic_tokens_disable
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[not vim.b[bufnr].user_lsp_semantic_tokens_disable and "start" or "stop"](
        bufnr,
        client.id
      )
      vim.notify(
        string.format(
          "Buffer lsp semantic highlighting %s",
          M.bool2str(not vim.b[bufnr].user_lsp_semantic_tokens_disable)
        )
      )
    end
  end
end

--- Toggle signcolumn="auto"|"no"
function M.toggle_signcolumn()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  vim.notify(string.format("signcolumn=%s", vim.wo.signcolumn))
end

--- Toggle spell
function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell -- local to window
  vim.notify(string.format("spell %s", M.bool2str(vim.wo.spell)))
end

--- Toggle laststatus=3|2|0
function M.toggle_statusline()
  local laststatus = vim.o.laststatus
  local status
  if laststatus == 0 then
    vim.o.laststatus = 2
    status = "local"
  elseif laststatus == 2 then
    vim.o.laststatus = 3
    status = "global"
  elseif laststatus == 3 then
    vim.o.laststatus = 0
    status = "off"
  end
  vim.notify(string.format("statusline %s", status))
end

--- Toggle wrap
function M.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap -- local to window
  vim.notify(string.format("wrap %s", M.bool2str(vim.wo.wrap)))
end

--
-- Decorations
--

---@class Decorations {
---@field winbar 'ignore' | boolean
---@field number boolean
---@field statusline 'minimal' | boolean
---@field statuscolumn boolean
---@field colorcolumn boolean | string

---@alias DecorationType 'statuscolumn'|'winbar'|'statusline'|'number'|'colorcolumn'

M.decorations = {}

---@type table<string, Decorations>
M.decorations.presets = {
  statusline_only = {
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = true,
    statuscolumn = false,
  },
  minimal_editing = {
    number = false,
    winbar = true,
    colorcolumn = false,
    statusline = "minimal",
    statuscolumn = false,
  },
  tool_panel = {
    number = false,
    winbar = false,
    colorcolumn = false,
    statusline = "minimal",
    statuscolumn = false,
  },
  commit_buffer = {
    number = false,
    winbar = false,
    colorcolumn = "50,72",
    statusline = "minimal",
    statuscolumn = false,
  },
}

local buftypes = {
  ["quickfix"] = M.decorations.presets.tool_panel,
  ["nofile"] = M.decorations.presets.tool_panel,
  ["nowrite"] = M.decorations.presets.tool_panel,
  ["acwrite"] = M.decorations.presets.tool_panel,
  ["terminal"] = M.decorations.presets.tool_panel,
}

--- Add a buftype to the buftypes list
---@param name string buftype name
---@param decorations Decorations
function M.decorations.append_buftype(name, decorations)
  buftypes[name] = decorations
end

local filetypes = {
  ["startuptime"] = M.decorations.presets.tool_panel,
  ["checkhealth"] = M.decorations.presets.tool_panel,
  ["log"] = M.decorations.presets.tool_panel,
  ["help"] = M.decorations.presets.tool_panel,
  ["list"] = M.decorations.presets.tool_panel,
  ["netrw"] = M.decorations.presets.tool_panel,
  ["query"] = M.decorations.presets.tool_panel,
  ["mail"] = M.decorations.presets.statusline_only,
  ["diff"] = M.decorations.presets.statusline_only,
  ["qf"] = M.decorations.presets.statusline_only,
  ["man"] = M.decorations.presets.minimal_editing,
  -- ["markdown"] = M.decorations.presets.minimal_editing,
  ["gitcommit"] = M.decorations.commit_buffer,
}

--- Add a filetype to the buftypes list
---@param name string filetype name
---@param decorations Decorations
function M.decorations.append_filetype(name, decorations)
  filetypes[name] = decorations
end

local filenames = {}

--- Add a filename to the buftypes list
---@param name string file name
---@param decorations Decorations
function M.decorations.append_filename(name, decorations)
  filenames[name] = decorations
end

---@alias decorations.OptionValue (boolean | string)

---Get the decorations setting for a particular filetype/buftype/filename
---@param opts {ft: string?, bt: string?, fname: string?, setting: DecorationType}
---@return {ft: decorations.OptionValue?, bt: decorations.OptionValue?, fname: decorations.OptionValue?}?
function M.decorations.get(opts)
  local ft, bt, fname, setting = opts.ft, opts.bt, opts.fname, opts.setting
  if (not ft and not bt and not fname) or not setting then
    return nil
  end
  return {
    ft = ft and filetypes[ft] and filetypes[ft][setting],
    bt = bt and buftypes[bt] and buftypes[bt][setting],
    fname = fname and filenames[fname] and filenames[fname][setting],
  }
end

return M
