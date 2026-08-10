vim.g.fff = {
  lazy_sync = false,
  debug = { enabled = true, show_scores = true },
}

exec_later(function()
  on_packchanged("fff.nvim", { "install", "update" }, function(ev)
    if not ev.data.active then
      vim.cmd.packadd("fff.nvim")
    end
    require("fff.download").download_or_build_binary()
  end, "Install fff binary")

  vim.pack.add({
    {
      src = "https://github.com/dmtrKovalenko/fff.nvim",
      version = vim.version.range("*"),
    },
  })

  local fff = require("fff")

  vim.keymap.set("n", "<leader><leader>", function()
    fff.find_files({})
  end, { desc = "FFFind files" })

  local fffmb_ok, fffmb = pcall(require, "minibuffer.integrations.fff")
  if fffmb_ok then
    vim.keymap.set("n", "<leader><leader>", function()
      fffmb.file_search({})
    end, { desc = "FFFind" })
    vim.keymap.set("n", "<leader>/", function()
      fffmb.content_search({})
    end, { desc = "FFFGrep" })
  end
end)
