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
}
