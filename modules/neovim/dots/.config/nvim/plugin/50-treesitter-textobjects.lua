local deps = require("mini.deps")

deps.add({
  source = "nvim-treesitter/nvim-treesitter-textobjects",
  checkout = "main",
})

deps.later(function()
  --
  -- Load plugin
  --

  local ts_context = require("nvim-treesitter-textobjects")
  ts_context.setup({
    {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    },
  })

  --
  -- Keymaps
  --

  local function ts_select_to(query_string)
    return function()
      require("nvim-treesitter-textobjects.select").select_textobject(
        query_string,
        "textobjects"
      )
    end
  end
  local function ts_swap(query_string, nextprev)
    if nextprev == 0 then
      return function()
        require("nvim-treesitter-textobjects.swap").swap_previous(query_string)
      end
    end
    return function()
      require("nvim-treesitter-textobjects.swap").swap_next(query_string)
    end
  end
  local function ts_jump_start(query_string, nextprev)
    if nextprev == 0 then
      return function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          query_string,
          "textobjects"
        )
      end
    end
    return function()
      require("nvim-treesitter-textobjects.move").goto_next_start(
        query_string,
        "textobjects"
      )
    end
  end
  local function ts_jump_end(query_string, nextprev)
    if nextprev == 0 then
      return function()
        require("nvim-treesitter-textobjects.move").goto_previous_end(
          query_string,
          "textobjects"
        )
      end
    end
    return function()
      require("nvim-treesitter-textobjects.move").goto_next_end(
        query_string,
        "textobjects"
      )
    end
  end

  -- Select
  vim.keymap.set(
    { "x", "o" },
    "a,",
    ts_select_to("@parameter.outer"),
    { desc = "parameter" }
  )
  vim.keymap.set(
    { "x", "o" },
    "i,",
    ts_select_to("@parameter.inner"),

    { desc = "inner parameter" }
  )
  vim.keymap.set({ "x", "o" }, "am", ts_select_to("@function.outer"), { desc = "method" })
  vim.keymap.set(
    { "x", "o" },
    "im",
    ts_select_to("@function.inner"),
    { desc = "inner method" }
  )
  vim.keymap.set({ "x", "o" }, "ac", ts_select_to("@class.outer"), { desc = "class" })
  vim.keymap.set(
    { "x", "o" },
    "ic",
    ts_select_to("@class.inner"),
    { desc = "inner class" }
  )
  -- Move
  vim.keymap.set(
    { "n", "x", "o" },
    "],",
    ts_jump_start("@parameter.outer", 1),
    { desc = "parameter start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]<",
    ts_jump_end("@parameter.outer", 1),

    { desc = "parameter end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[,",
    ts_jump_start("@parameter.outer", 0),

    { desc = "parameter start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[>",
    ts_jump_end("@parameter.outer", 0),

    { desc = "parameter end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "].",
    ts_jump_start("@block.outer", 1),

    { desc = "block start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]>",
    ts_jump_end("@block.outer", 1),
    { desc = "block end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[.",
    ts_jump_start("@block.outer", 0),

    { desc = "block start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[>",
    ts_jump_end("@block.outer", 0),
    { desc = "block end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]m",
    ts_jump_start("@function.outer", 1),

    { desc = "method start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]M",
    ts_jump_end("@function.outer", 1),

    { desc = "method end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[m",
    ts_jump_start("@function.outer", 0),

    { desc = "method start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[M",
    ts_jump_end("@function.outer", 0),

    { desc = "method end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]c",
    ts_jump_start("@class.outer", 1),

    { desc = "class start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "]C",
    ts_jump_end("@class.outer", 1),
    { desc = "class end" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[c",
    ts_jump_start("@class.outer", 0),

    { desc = "class start" }
  )
  vim.keymap.set(
    { "n", "x", "o" },
    "[C",
    ts_jump_end("@class.outer", 0),
    { desc = "class end" }
  )
  -- Swap
  vim.keymap.set(
    "n",
    "<M-C-L>",
    ts_swap("@parameter.inner", 1),
    { desc = "Swap next parameter" }
  )
  vim.keymap.set(
    "n",
    "<M-C-H>",
    ts_swap("@parameter.inner", 0),
    { desc = "Swap prev parameter" }
  )
end)
