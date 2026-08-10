exec_later(function()
  vim.pack.add({
    {
      src = "https://github.com/folke/which-key.nvim",
      version = vim.version.range("*"),
    },
  })

  local win
  -- local msgarea_ok, _ = pcall(require, "msgarea")
  -- if msgarea_ok then
  --   win = {
  --     relative = "msgarea",
  --     force_msgarea = true,
  --   }
  -- end
  local minibuffer_ok, _ = pcall(require, "minibuffer")
  if minibuffer_ok then
    win = { use_minibuffer = true }
  end

  require("which-key").setup({
    delay = 500,
    icons = {
      rules = false,
    },
    disable = { filetypes = { "TelescopePrompt" } },
    spec = {
      {
        mode = { "n", "v" },
        { "<C-w>", group = "+Window" },
        { "[", group = "+Prev" },
        { "]", group = "+Next" },
        { "g", group = "+Goto" },
        { "gr", group = "+Lsp" },
        { "grw", group = "+Workspace" },
        { "<localleader>", group = "+Local" },
        { "<leader>", group = "+Global" },
        { "<leader><tab>", group = "+Tab" },
        { "<leader>b", group = "+Buffer" },
        { "<leader>c", group = "+Code" },
        { "<leader>f", group = "+File" },
        { "<leader>g", group = "+Git" },
        { "<leader>h", group = "+Help" },
        { "<leader>n", group = "+Notes" },
        { "<leader>p", group = "+Project" },
        { "<leader>q", group = "+Quit/Session" },
        { "<leader>u", group = "+Ui" },
      },
    },
    win = win,
  })

  pcall(vim.api.nvim_set_hl, 0, "WhichKeyNormal", { link = "Normal" })
end)
