vim.g.minibuffer = {
  cmd = {
    enabled = true,
    dynamic_height = false,
    max_height = 15,
  },
}

exec_now(function()
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
    require("minibuffer.examples.buffers"),
    { desc = "Find buffers" }
  )
  vim.keymap.set("n", "<leader>;", function()
    require("minibuffer.examples.history")({ type = "cmd" })
  end, { desc = "Find command history" })
  vim.keymap.set("n", "<leader>?", function()
    require("minibuffer.examples.history")({ type = "search" })
  end, { desc = "Find command history" })
  vim.keymap.set("n", "<leader>'", function()
    require("minibuffer.examples.marks")()
  end, { desc = "Find mark" })

  -- Keymaps: Leader + b (buffer)
  vim.keymap.set(
    "n",
    "<leader>bf",
    require("minibuffer.examples.buffers"),
    { desc = "Find" }
  )

  -- <leader> + c
  vim.keymap.set("n", "<leader>cd", function()
    require("minibuffer.examples.diagnostics")({ scope = "buffer" })
  end, { desc = "Diagnostics" })
  vim.keymap.set("n", "<leader>cD", function()
    require("minibuffer.examples.diagnostics")({ scope = "workspace" })
  end, { desc = "Diagnostics (workspace)" })
  vim.keymap.set("n", "<leader>cl", function()
    require("minibuffer.examples.list")({ type = "loclist" })
  end, { desc = "Loclist" })
  vim.keymap.set("n", "<leader>cq", function()
    require("minibuffer.examples.list")({ type = "quickfix" })
  end, { desc = "Quickfix" })

  -- <leader> + f
  vim.keymap.set("n", "<leader>fc", function()
    require("minibuffer.examples.files")({
      cwd = vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
    })
  end, { desc = "Find config" })
  vim.keymap.set(
    "n",
    "<leader>ff",
    require("minibuffer.examples.files"),
    { desc = "Find file" }
  )
  vim.keymap.set("n", "<leader>fo", function()
    require("minibuffer.examples.oldfiles")({ cwd = vim.fn.getcwd() })
  end, { desc = "Oldfiles (cwd)" })
  vim.keymap.set(
    "n",
    "<leader>fO",
    require("minibuffer.examples.oldfiles"),
    { desc = "Oldfiles" }
  )

  -- Keymaps: Leader + g (git)
  vim.keymap.set(
    "n",
    "<leader>gf",
    require("minibuffer.examples.git-files"),
    { desc = "Find file" }
  )

  -- Keymaps: Leader + h (help)
  vim.keymap.set(
    "n",
    "<leader>hm",
    require("minibuffer.examples.manpages"),
    { desc = "Manpages" }
  )
end)
