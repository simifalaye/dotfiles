local file_template = [[
# {{ title }}
Date: {{ date }}
]]
return {
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    cmd = {
      "MarkdownPreview",
      "MarkdownPreviewStop",
      "MarkdownPreviewToggle",
    },
    config = function()
      vim.g.mkdp_preview_options = {
        disable_sync_scroll = true,
      }
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      perspective = {
        priority = "current",
      },
      silent = true,
      new_file_template = {
        use_template = true,
        template = file_template,
        placeholders = {
          before = {
            date = function()
              return os.date("%A, %B %d, %Y") -- Wednesday, March 1, 2023
            end,
          },
          after = { },
        },
      },
      mappings = {
        MkdnEnter = { { "n", "v" }, "<CR>" },
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = { "n", "<Tab>" },
        MkdnPrevLink = { "n", "<S-Tab>" },
        MkdnNextHeading = { "n", "]]" },
        MkdnPrevHeading = { "n", "[[" },
        MkdnGoBack = { "n", "<BS>" },
        MkdnGoForward = { "n", "<Del>" },
        MkdnCreateLink = false, -- see MkdnEnter
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<localleader>p" }, -- see MkdnEnter
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { "n", "<M-CR>" },
        MkdnTagSpan = { "v", "<M-CR>" },
        MkdnMoveSource = { "n", "<F2>" },
        MkdnYankAnchorLink = { "n", "yaa" },
        MkdnYankFileAnchorLink = { "n", "yfa" },
        MkdnIncreaseHeading = { "n", "H" },
        MkdnDecreaseHeading = { "n", "L" },
        MkdnToggleToDo = { { "n", "v" }, "<localleader>t" },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = { "n", "o" },
        MkdnNewListItemAboveInsert = { "n", "O" },
        MkdnExtendList = false,
        MkdnUpdateNumbering = { "n", "<localleader>n" },
        MkdnTableNextCell = { "i", "<Tab>" },
        MkdnTablePrevCell = { "i", "<S-Tab>" },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { "i", "<M-CR>" },
        MkdnTableNewRowBelow = { "n", "<localleader>r" },
        MkdnTableNewRowAbove = { "n", "<localleader>R" },
        MkdnTableNewColAfter = { "n", "<localleader>c" },
        MkdnTableNewColBefore = { "n", "<localleader>C" },
        MkdnFoldSection = false,
        MkdnUnfoldSection = false,
      },
    },
  },
}
