return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done({
            tex = false,
          })
        )
      end

      -- Configure toggle command/keymap
      local command = require("utils.command").command
      local utils = require("utils")
      local ui = require("utils.ui")
      local m = require("utils.map")
      command("ToggleAutopairs", function(_)
        if autopairs.state.disabled then
          autopairs.enable()
        else
          autopairs.disable()
        end
        vim.g.autopairs_enabled = autopairs.state.disabled
        ui.ui_notify(
          string.format("autopairs %s", utils.bool2str(not autopairs.state.disabled))
        )
      end, { desc = "Toggle the autopairs plugin" })
      m.nnoremap("<leader>ua", "<cmd>ToggleAutopairs<CR>", "Toggle autopairs")

      -- Set to enabled initially
      vim.g.autopairs_enabled = true
    end,
  },
}
