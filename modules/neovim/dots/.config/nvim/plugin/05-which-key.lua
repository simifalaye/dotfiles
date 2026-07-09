vim.schedule(function()
  vim.pack.add({
    {
      src = "https://github.com/folke/which-key.nvim",
      version = vim.version.range("*"),
    },
  })

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
        { "<leader>p", group = "+Project" },
        { "<leader>q", group = "+Quit/Session" },
        { "<leader>u", group = "+Ui" },
      },
    },
  })

  -- TODO: Revisit
  -- ---@class wk.Win.opts
  -- local override = {
  --   relative = "msgarea",
  --   style = "minimal",
  --   focusable = false,
  --   noautocmd = true,
  --   wo = {
  --     scrolloff = 0,
  --     foldenable = false,
  --     winhighlight = "Normal:WhichKeyNormal,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle",
  --     winbar = "",
  --     statusline = "",
  --     wrap = false,
  --   },
  --   bo = {
  --     buftype = "nofile",
  --     bufhidden = "wipe",
  --     filetype = "wk",
  --   },
  -- }
  --
  -- ---@type wk.Win.opts
  -- local defaults = { col = 0, row = math.huge, zindex = 1000 }
  --
  -- -- local wk_win_defaults = require("which-key.win").defaults
  -- require("which-key.win").defaults = function(opts)
  --   return vim.tbl_deep_extend("force", {}, defaults, opts or {}, override)
  -- end
end)
