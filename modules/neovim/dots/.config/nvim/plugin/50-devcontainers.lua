MiniDeps.later(function()
  MiniDeps.add({
    source = "jedrzejboczar/devcontainers.nvim",
    depends = { "miversen33/netman.nvim" },
  })

  if vim.fn.executable("devcontainer") <= 0 then
    vim.notify("Install devcontainer-cli: sudo npm install -g @devcontainers/cli")
  end

  -- FIX: Issue with docker file buffer not being modifiable/writable for netman
  vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = "docker://*",
    callback = function()
      vim.bo.modifiable = true
    end,
  })

  require("devcontainers").setup({})
end)
