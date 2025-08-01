local deps = require("mini.deps")

deps.add({
  source = "windwp/nvim-autopairs",
})

deps.now(function()
  local autopairs_enabled = true
  local lz = require("utils.lazy").new("autopairs", function()
    require("nvim-autopairs").setup({
      enabled = function(_)
        return autopairs_enabled
      end,
      check_ts = true,
      ts_config = { java = false },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = ([[ [%'%"%)%>%]%)%}%,] ]]):gsub("%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    })
  end)
  lz:events({ "InsertEnter" }, "*")
  lz:key("n", "<leader>ua", function()
    if autopairs_enabled then
      autopairs_enabled = false
    else
      autopairs_enabled = true
    end

    local state = autopairs_enabled
    vim.notify(string.format("autopairs %s", require("utils.ui").bool2str(not state)))
  end, { desc = "Toggle autopairs" })
end)
