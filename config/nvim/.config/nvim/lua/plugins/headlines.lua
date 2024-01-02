local hl_opts = {
  fat_headlines = true,
  fat_headline_upper_string = "▃",
  fat_headline_lower_string = "▀",
}
return {
  {
    "lukas-reineke/headlines.nvim",
    ft = { "org", "norg", "markdown", "yaml" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = hl_opts,
      norg = hl_opts,
      org = hl_opts,
      rmd = hl_opts,
    },
  },
}
