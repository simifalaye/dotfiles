vim.schedule(function()
  vim.pack.add({
    {
      src = "https://github.com/folke/which-key.nvim",
      version = vim.version.range("*"),
    },
  })

  require("which-key").setup({
    preset = "helix",
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
        { "<leader>f", group = "+File" },
        { "<leader>g", group = "+Git" },
        { "<leader>h", group = "+Help" },
        { "<leader>q", group = "+Quit/Session" },
        { "<leader>u", group = "+Ui" },
      },
    },
  })

  local mb_ok, _ = pcall(require, "minibuffer")
  if mb_ok then
    -- NOTE: after loading plugin
    local wk_mb = require("minibuffer.integrations.which-key")
    local wk_view = require("which-key.view")
    wk_view.show = wk_mb.show
    wk_view.hide = wk_mb.hide
  end
end)
