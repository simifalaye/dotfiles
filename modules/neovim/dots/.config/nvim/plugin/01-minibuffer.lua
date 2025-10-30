MiniDeps.now(function()
  MiniDeps.add({
    source = "simifalaye/minibuffer.nvim",
  })

  if vim.fn.has("nvim-0.12") == 1 then
    local minibuffer = require("minibuffer")
    minibuffer.initialize()

    vim.ui.select = require("minibuffer.builtin.ui_select")
    vim.ui.input = require("minibuffer.builtin.ui_input")

    vim.keymap.set("n", "<M-;>", require("minibuffer.builtin.cmdline"))
    vim.keymap.set("n", "<M-.>", function()
      minibuffer.resume(true)
    end)

    vim.keymap.set(
      "n",
      "<leader>,",
      require("minibuffer.examples.buffers"),
      { desc = "Find buffer" }
    )
    vim.keymap.set(
      "n",
      "<leader>/",
      require("minibuffer.examples.live-grep"),
      { desc = "Find text" }
    )
    vim.keymap.set(
      "n",
      "<leader>fo",
      require("minibuffer.examples.oldfiles"),
      { desc = "Find oldfile" }
    )
    vim.keymap.set("n", "<leader>fO", function()
      require("minibuffer.examples.oldfiles")({ cwd = vim.fn.getcwd() })
    end, { desc = "Find oldfile (all)" })
  end
end)
