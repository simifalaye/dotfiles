MiniDeps.later(function()
  local function build()
    require("fff.download").download_or_build_binary()
  end

  MiniDeps.add({
    source = "dmtrKovalenko/fff.nvim",
    hooks = {
      post_install = function()
        MiniDeps.later(build)
      end,
      post_checkout = build,
    },
  })

  vim.keymap.set("n", "<leader><leader>", function()
    require("fff").find_files()
  end)

  if vim.fn.has("nvim-0.12") == 1 then
    local picker_ui = require("fff.picker_ui")
    picker_ui.open = require("minibuffer.integrations.fff")
  end
end)
