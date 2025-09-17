MiniDeps.later(function()
  -- Do not close the preview tab when switching to other buffers
  vim.g.mkdp_auto_close = 0

  local build = function()
    vim.fn["mkdp#util#install"]()
  end
  MiniDeps.add({
    source = "iamcco/markdown-preview.nvim",
    hooks = {
      post_install = function()
        MiniDeps.later(build)
      end,
      post_checkout = build,
    },
  })
end)
