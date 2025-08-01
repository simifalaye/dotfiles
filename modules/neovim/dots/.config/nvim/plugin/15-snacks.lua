local deps = require("mini.deps")

deps.add({
  source = "folke/snacks.nvim",
})

deps.now(function()
  local snacks = require("snacks")
  snacks.setup({
    bigfile = { enabled = true },
    dashboard = { enabled = false },
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
  })

  -- Setup some globals for debugging (lazy-loaded)
  _G.dd = function(...)
    snacks.debug.inspect(...)
  end
  _G.bt = function()
    snacks.debug.backtrace()
  end
  vim.print = _G.dd -- Override print to use snacks for `:=` command

  -- Setup lsp progress notification
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

  --
  -- Keymaps
  --

  local picker = snacks.picker
  local bufdelete = snacks.bufdelete
  local files_opts = { hidden = true }
  local all_files_opts = { hidden = true, ignored = true }

  -- Root
  vim.keymap.set("n", "g{", picker.notifications, { desc = "Show notification history" })
  vim.keymap.set("n", "g}", function()
    require("snacks.notifier").hide()
  end, { desc = "Clear notifications" })
  vim.keymap.set(
    "n",
    "<leader>;",
    picker.command_history,
    { desc = "Open Command History Picker" }
  )
  vim.keymap.set("n", "<leader>:", picker.commands, { desc = "Open Commands Picker" })
  vim.keymap.set("n", "<leader>'", picker.marks, { desc = "Open Marks Picker" })
  vim.keymap.set("n", '<leader>"', picker.registers, { desc = "Open Registers Picker" })
  vim.keymap.set("n", "<leader><CR>", picker.resume, { desc = "Resume Picker" })
  vim.keymap.set("n", "<leader>,", picker.buffers, { desc = "Open Buffers Picker" })
  vim.keymap.set("n", "<leader>.", function()
    picker.files(files_opts)
  end, { desc = "Open Files Picker" })
  vim.keymap.set("n", "<leader>/", function()
    picker.grep(files_opts)
  end, { desc = "Open Live Grep Picker" })
  -- Buffer
  vim.keymap.set("n", "<leader>bd", bufdelete.delete, { desc = "Delete" })
  vim.keymap.set("n", "<leader>bd", function()
    bufdelete.delete({ wipe = true })
  end, { desc = "Wipeout" })
  -- Find
  vim.keymap.set("n", "<leader>f;", picker.command_history, { desc = "Command History" })
  vim.keymap.set("n", "<leader>f:", picker.commands, { desc = "Commands" })
  vim.keymap.set("n", "<leader>f<CR>", picker.resume, { desc = "Resume" })
  vim.keymap.set("n", "<leader>f'", picker.marks, { desc = "Marks" })
  vim.keymap.set("n", '<leader>f"', picker.registers, { desc = "Registers" })
  vim.keymap.set("n", "<leader>f/", picker.lines, { desc = "Buffer lines" })
  vim.keymap.set("n", "<leader>fa", picker.autocmds, { desc = "Autocommands" })
  vim.keymap.set("n", "<leader>fb", picker.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fd", picker.diagnostics, { desc = "Diagnostics" })
  vim.keymap.set("n", "<leader>ff", function()
    picker.files(files_opts)
  end, { desc = "Files" })
  vim.keymap.set("n", "<leader>fF", function()
    picker.files(all_files_opts)
  end, { desc = "Files (all)" })
  vim.keymap.set("n", "<leader>fg", function()
    picker.grep(files_opts)
  end, { desc = "Grep" })
  vim.keymap.set("n", "<leader>fh", picker.help, { desc = "Help" })
  vim.keymap.set("n", "<leader>fH", picker.highlights, { desc = "Highlights" })
  vim.keymap.set("n", "<leader>fk", picker.keymaps, { desc = "Keymaps" })
  vim.keymap.set("n", "<leader>fl", picker.loclist, { desc = "Location list" })
  vim.keymap.set("n", "<leader>fm", picker.man, { desc = "Man pages" })
  vim.keymap.set("n", "<leader>fr", function()
    picker.recent({ cwd = vim.fn.getcwd() })
  end, { desc = "Recents (cwd)" })
  vim.keymap.set("n", "<leader>fR", picker.recent, { desc = "Recents" })
  vim.keymap.set("n", "<leader>fs", picker.lsp_symbols, { desc = "Lsp Symbols" })
  vim.keymap.set("n", "<leader>fq", picker.qflist, { desc = "Quickfix list" })
end)
