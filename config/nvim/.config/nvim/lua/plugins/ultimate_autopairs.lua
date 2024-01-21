---Record previous cmdline completion types,
---cmdcompltype[1] is the current completion type,
---cmdcompltype[2] is the previous completion type
---@type string[]
local compltype = {}

-- Matches strings that start with:
-- keywords: \k
-- opening pairs: (, [, {, \(, \[, \{
local IGNORE_REGEX = vim.regex([=[^\%(\k\|\\\?[([{]\)]=])

---Get next two characters after cursor, whether in cmdline or normal buffer
---@return string: next two characters
local function get_next_two_chars()
  local col, line
  if vim.fn.mode():match("^c") then
    col = vim.fn.getcmdpos()
    line = vim.fn.getcmdline()
  else
    col = vim.fn.col(".")
    line = vim.api.nvim_get_current_line()
  end
  return line:sub(col, col + 1)
end

return {
  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
      extensions = {
        -- Improve performance when typing fast, see
        -- https://github.com/altermo/ultimate-autopair.nvim/issues/74
        tsnode = false,
        utf8 = false,
        filetype = { tree = false },
        cond = {
          cond = function(f)
            return not f.in_macro()
              -- Disable autopairs if followed by a keyword or an opening pair
              and IGNORE_REGEX
              and not IGNORE_REGEX:match_str(get_next_two_chars())
              -- Disable autopairs when inserting a regex,
              -- e.g. `:s/{pattern}/{string}/[flags]` or
              -- `:g/{pattern}/[cmd]`, etc.
              and (not f.in_cmdline() or compltype[1] ~= "" or compltype[2] ~= "command")
          end,
        },
      },
      { "\\(", "\\)" },
      { "\\[", "\\]" },
      { "\\{", "\\}" },
      { "[=[", "]=]", ft = { "lua" } },
      { "<<<", ">>>", ft = { "cuda" } },
      {
        "/*",
        "*/",
        ft = { "c", "cpp", "cuda" },
        newline = true,
        space = true,
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("CmdlineChanged", {
        desc = "Record cmd compltype to determine whether to autopair.",
        callback = function()
          local type = vim.fn.getcmdcompltype()
          if compltype[1] == type then
            return
          end
          compltype[2] = compltype[1]
          compltype[1] = type
        end,
      })
      -- Setup plugin
      require("ultimate-autopair").setup(opts)
    end,
  },
}
