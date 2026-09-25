local lazy = require("utils.lazy")

vim.g.minibuffer = {
  dynamic_window_resize = true,
  cmd = {
    enabled = true,
    autotrigger = true,
    dynamic_height = false,
    max_height = 15,
  },
}

lazy.now(function()
  local local_path = vim.fs.joinpath(vim.env.HOME, "dev", "oss", "minibuffer.nvim")
  if require("utils.fs").dir_exists(local_path) then
    vim.opt.runtimepath:prepend(
      vim.fs.joinpath(vim.env.HOME, "dev", "oss", "minibuffer.nvim")
    )
    vim.cmd("runtime plugin/minibuffer.lua")
  else
    vim.pack.add({
      {
        src = "https://github.com/simifalaye/minibuffer.nvim",
      },
    })
  end

  local minibuffer = require("minibuffer")

  vim.ui.select = require("minibuffer.builtin.ui_select")
  vim.ui.input = require("minibuffer.builtin.ui_input")

  vim.keymap.set("n", "<leader><CR>", function()
    minibuffer.resume(true)
  end, { desc = "Resume minibuffer" })

  -- <leader> + symbol
  vim.keymap.set(
    "n",
    "<leader>,",
    require("minibuffer.builtin.buffers"),
    { desc = "Find buffers" }
  )
  vim.keymap.set("n", "<leader>;", function()
    require("minibuffer.builtin.history")({ type = "cmd" })
  end, { desc = "Find command history" })
  vim.keymap.set("n", "<leader>?", function()
    require("minibuffer.builtin.history")({ type = "search" })
  end, { desc = "Find command history" })
  vim.keymap.set("n", "<leader>'", function()
    require("minibuffer.builtin.marks")()
  end, { desc = "Find mark" })

  -- Keymaps: Leader + b (buffer)
  vim.keymap.set(
    "n",
    "<leader>bf",
    require("minibuffer.builtin.buffers"),
    { desc = "Find" }
  )

  -- <leader> + c
  vim.keymap.set("n", "<leader>cd", function()
    require("minibuffer.builtin.diagnostics")({ scope = "buffer" })
  end, { desc = "Diagnostics" })
  vim.keymap.set("n", "<leader>cD", function()
    require("minibuffer.builtin.diagnostics")({ scope = "workspace" })
  end, { desc = "Diagnostics (workspace)" })
  vim.keymap.set("n", "<leader>cl", function()
    require("minibuffer.builtin.list")({ type = "loclist" })
  end, { desc = "Loclist" })
  vim.keymap.set("n", "<leader>cq", function()
    require("minibuffer.builtin.list")({ type = "quickfix" })
  end, { desc = "Quickfix" })

  -- <leader> + f
  vim.keymap.set("n", "<leader>fc", function()
    require("minibuffer.builtin.files")({
      cwd = vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
    })
  end, { desc = "Find config" })
  vim.keymap.set(
    "n",
    "<leader>ff",
    require("minibuffer.builtin.files"),
    { desc = "Find file" }
  )
  vim.keymap.set("n", "<leader>fo", function()
    require("minibuffer.builtin.oldfiles")({ cwd = vim.fn.getcwd() })
  end, { desc = "Oldfiles (cwd)" })
  vim.keymap.set(
    "n",
    "<leader>fO",
    require("minibuffer.builtin.oldfiles"),
    { desc = "Oldfiles" }
  )

  -- Keymaps: Leader + g (git)
  vim.keymap.set(
    "n",
    "<leader>gf",
    require("minibuffer.builtin.git-files"),
    { desc = "Find file" }
  )

  -- Keymaps: Leader + h (help)
  vim.keymap.set(
    "n",
    "<leader>hm",
    require("minibuffer.builtin.manpages"),
    { desc = "Manpages" }
  )
end)
