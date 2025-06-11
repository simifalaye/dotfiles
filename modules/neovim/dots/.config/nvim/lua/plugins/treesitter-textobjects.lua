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
    require("nvim-treesitter-textobjects.move").goto_next_end(query_string, "textobjects")
  end
end

local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  version = false,
  branch = "main",
}

M.keys = {
  -- Select
  { "a,", ts_select_to("@parameter.outer"), mode = { "x", "o" }, desc = "parameter" },
  {
    "i,",
    ts_select_to("@parameter.inner"),
    mode = { "x", "o" },
    desc = "inner parameter",
  },
  { "a.", ts_select_to("@block.outer"), mode = { "x", "o" }, desc = "block" },
  { "i.", ts_select_to("@block.inner"), mode = { "x", "o" }, desc = "inner block" },
  { "am", ts_select_to("@function.outer"), mode = { "x", "o" }, desc = "method" },
  { "im", ts_select_to("@function.inner"), mode = { "x", "o" }, desc = "inner method" },
  { "ac", ts_select_to("@class.outer"), mode = { "x", "o" }, desc = "class" },
  { "ic", ts_select_to("@class.inner"), mode = { "x", "o" }, desc = "inner class" },
  -- Move
  {
    "],",
    ts_jump_start("@parameter.outer", 1),
    mode = { "n", "x", "o" },
    desc = "parameter start",
  },
  {
    "]<",
    ts_jump_end("@parameter.outer", 1),
    mode = { "n", "x", "o" },
    desc = "parameter end",
  },
  {
    "[,",
    ts_jump_start("@parameter.outer", 0),
    mode = { "n", "x", "o" },
    desc = "parameter start",
  },
  {
    "[>",
    ts_jump_end("@parameter.outer", 0),
    mode = { "n", "x", "o" },
    desc = "parameter end",
  },
  {
    "].",
    ts_jump_start("@block.outer", 1),
    mode = { "n", "x", "o" },
    desc = "block start",
  },
  {
    "]>",
    ts_jump_end("@block.outer", 1),
    mode = { "n", "x", "o" },
    desc = "block end",
  },
  {
    "[.",
    ts_jump_start("@block.outer", 0),
    mode = { "n", "x", "o" },
    desc = "block start",
  },
  {
    "[>",
    ts_jump_end("@block.outer", 0),
    mode = { "n", "x", "o" },
    desc = "block end",
  },
  {
    "]m",
    ts_jump_start("@function.outer", 1),
    mode = { "n", "x", "o" },
    desc = "method start",
  },
  {
    "]M",
    ts_jump_end("@function.outer", 1),
    mode = { "n", "x", "o" },
    desc = "method end",
  },
  {
    "[m",
    ts_jump_start("@function.outer", 0),
    mode = { "n", "x", "o" },
    desc = "method start",
  },
  {
    "[M",
    ts_jump_end("@function.outer", 0),
    mode = { "n", "x", "o" },
    desc = "method end",
  },
  {
    "]c",
    ts_jump_start("@class.outer", 1),
    mode = { "n", "x", "o" },
    desc = "class start",
  },
  {
    "]C",
    ts_jump_end("@class.outer", 1),
    mode = { "n", "x", "o" },
    desc = "class end",
  },
  {
    "[c",
    ts_jump_start("@class.outer", 0),
    mode = { "n", "x", "o" },
    desc = "class start",
  },
  {
    "[C",
    ts_jump_end("@class.outer", 0),
    mode = { "n", "x", "o" },
    desc = "class end",
  },
  -- Swap
  { "<M-C-L>", ts_swap("@parameter.inner", 1), desc = "Swap next parameter" },
  { "<M-C-H>", ts_swap("@parameter.inner", 0), desc = "Swap prev parameter" },
}

M.opts = {
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
}

return M
