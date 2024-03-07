return {
  {
    "catppuccin/nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    init = function()
      vim.o.termguicolors = true
    end,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      term_colors = true,
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      integrations = {
        alpha = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        cmp = true,
        fidget = true,
        gitsigns = true,
        headlines = true,
        markdown = true,
        mason = true,
        mini = {
          enabled = true,
        },
        neogit = true,
        notify = true,
        nvimtree = false,
        overseer = true,
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
