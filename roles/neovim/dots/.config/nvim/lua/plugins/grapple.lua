return {
  {
    "cbochs/grapple.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    init = function()
      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.register({ ["<leader>t"] = { name = "+tag" } })
      end
    end,
    keys = {
      { "<C-n>", "<cmd>Grapple cycle forward<cr>", desc = "Grapple cycle forward" },
      { "<C-p>", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },
      { "<leader>t1", "<cmd>Grapple select index=1<cr>", desc = "Select 1" },
      { "<leader>t2", "<cmd>Grapple select index=2<cr>", desc = "Select 2" },
      { "<leader>t3", "<cmd>Grapple select index=3<cr>", desc = "Select 3" },
      { "<leader>t4", "<cmd>Grapple select index=4<cr>", desc = "Select 4" },
      { "<leader>tt", "<cmd>Grapple toggle<cr>", desc = "Toggle" },
      {
        "<leader>tl",
        function()
          local ok, telescope = pcall(require, "telescope")
          if not ok then
            require("grapple").toggle_tags()
            return
          end
          if telescope.extensions.grapple == nil then
            telescope.load_extension("grapple")
          end
          telescope.extensions.grapple.tags()
        end,
        desc = "List",
      },
      { "<leader>ts", "<cmd>Grapple toggle_scopes<cr>", desc = "Scopes" },
    },
    opts = {
      scope = "git", -- also try out "git_branch"
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
  },
}
