local files_opts = { hidden = true }
local all_files_opts = { hidden = true, ignored = true }
local picker = reqcall("snacks.picker") ---@module 'snacks.picker'
local bufdelete = reqcall("snacks.bufdelete") ---@module 'snacks.bufdelete'

local M = {
  "folke/snacks.nvim",
}

M.priority = 1000

M.lazy = false

M.keys = {
  -- Root
  {
    "g{",
    picker.notifications,
    desc = "Show notification history",
  },
  {
    "g}",
    function()
      require("snacks.notifier").hide()
    end,
    desc = "Clear notifications",
  },
  {
    "<leader>;",
    picker.command_history,
    desc = "Open Command History Picker",
  },
  {
    "<leader>:",
    picker.commands,
    desc = "Open Commands Picker",
  },
  { "<leader>'", picker.marks, desc = "Open Marks Picker" },
  {
    '<leader>"',
    picker.registers,
    desc = "Open Registers Picker",
  },
  { "<leader><CR>", picker.resume, desc = "Resume Picker" },
  {
    "<leader>,",
    picker.buffers,
    desc = "Open Buffers Picker",
  },
  {
    "<leader>.",
    function()
      picker.files(files_opts)
    end,
    desc = "Open Files Picker",
  },
  {
    "<leader>/",
    function()
      picker.grep(files_opts)
    end,
    desc = "Open Live Grep Picker",
  },
  -- Buffer
  { "<leader>bd", bufdelete.delete, desc = "Delete" },
  {
    "<leader>bd",
    function()
      bufdelete.delete({ wipe = true })
    end,
    desc = "Wipeout",
  },
  -- Find
  {
    "<leader>f;",
    picker.command_history,
    desc = "Command History",
  },
  { "<leader>f:", picker.commands, desc = "Commands" },
  { "<leader>f<CR>", picker.resume, desc = "Resume" },
  { "<leader>f'", picker.marks, desc = "Marks" },
  { '<leader>f"', picker.registers, desc = "Registers" },
  { "<leader>f/", picker.lines, desc = "Buffer lines" },
  { "<leader>fa", picker.autocmds, desc = "Autocommands" },
  { "<leader>fb", picker.buffers, desc = "Buffers" },
  { "<leader>fd", picker.diagnostics, desc = "Diagnostics" },
  {
    "<leader>ff",
    function()
      picker.files(files_opts)
    end,
    desc = "Files",
  },
  {
    "<leader>fF",
    function()
      picker.files(all_files_opts)
    end,
    desc = "Files (all)",
  },
  {
    "<leader>fg",
    function()
      picker.grep(files_opts)
    end,
    desc = "Grep",
  },
  { "<leader>fh", picker.help, desc = "Help" },
  { "<leader>fH", picker.highlights, desc = "Highlights" },
  { "<leader>fk", picker.keymaps, desc = "Keymaps" },
  { "<leader>fl", picker.loclist, desc = "Location list" },
  { "<leader>fm", picker.man, desc = "Man pages" },
  {
    "<leader>fr",
    function()
      picker.recent({ cwd = vim.fn.getcwd() })
    end,
    desc = "Recents (cwd)",
  },
  { "<leader>fR", picker.recent, desc = "Recents" },
  { "<leader>fs", picker.lsp_symbols, desc = "Lsp Symbols" },
  { "<leader>fq", picker.qflist, desc = "Quickfix list" },
}

M.opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true, animate = { enabled = false } },
  input = { enabled = true },
  picker = {
    enabled = true,
  },
  notifier = { enabled = true, style = "minimal" },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
}

M.init = function()
  -- Setup some globals for debugging (lazy-loaded)
  _G.dd = function(...)
    Snacks.debug.inspect(...)
  end
  _G.bt = function()
    Snacks.debug.backtrace()
  end
  vim.print = _G.dd -- Override print to use snacks for `:=` command
end

M.config = function(_, opts)
  local snacks = require("snacks")
  snacks.setup(opts)

  -- Setup lsp progress
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner =
        { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
    end,
  })
end

return M
