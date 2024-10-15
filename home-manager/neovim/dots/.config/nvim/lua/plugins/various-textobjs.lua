vim.keymap.set(
  { "o", "x" },
  "ai",
  '<cmd>lua require("various-textobjs").indentation("outer", "outer")<CR>',
  { desc = "A Indent" }
)
vim.keymap.set(
  { "o", "x" },
  "ii",
  '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>',
  { desc = "Inner Indent" }
)
vim.keymap.set(
  { "o", "x" },
  "ab",
  '<cmd>lua require("various-textobjs").anyBracket("outer")<CR>',
  { desc = "A Bracket" }
)
vim.keymap.set(
  { "o", "x" },
  "ib",
  '<cmd>lua require("various-textobjs").anyBracket("inner")<CR>',
  { desc = "Inner Bracket" }
)
vim.keymap.set(
  { "o", "x" },
  "ig",
  '<cmd>lua require("various-textobjs").entireBuffer()<CR>',
  { desc = "Inner Buffer" }
)
vim.keymap.set(
  { "o", "x" },
  "ak",
  '<cmd>lua require("various-textobjs").key("outer")<CR>',
  { desc = "A Key" }
)
vim.keymap.set(
  { "o", "x" },
  "ik",
  '<cmd>lua require("various-textobjs").key("inner")<CR>',
  { desc = "Inner Key" }
)
vim.keymap.set(
  { "o", "x" },
  "al",
  '<cmd>lua require("various-textobjs").lineCharacterwise("outer")<CR>',
  { desc = "A Line" }
)
vim.keymap.set(
  { "o", "x" },
  "il",
  '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<CR>',
  { desc = "Inner Line" }
)
vim.keymap.set(
  { "o", "x" },
  "an",
  '<cmd>lua require("various-textobjs").number("outer")<CR>',
  { desc = "A Number" }
)
vim.keymap.set(
  { "o", "x" },
  "in",
  '<cmd>lua require("various-textobjs").number("inner")<CR>',
  { desc = "Inner Number" }
)
vim.keymap.set(
  { "o", "x" },
  "aq",
  '<cmd>lua require("various-textobjs").anyQuote("outer")<CR>',
  { desc = "A Quote" }
)
vim.keymap.set(
  { "o", "x" },
  "iq",
  '<cmd>lua require("various-textobjs").anyQuote("inner")<CR>',
  { desc = "Inner Quote" }
)
vim.keymap.set(
  { "o", "x" },
  "as",
  '<cmd>lua require("various-textobjs").subword("outer")<CR>',
  { desc = "A Subword" }
)
vim.keymap.set(
  { "o", "x" },
  "is",
  '<cmd>lua require("various-textobjs").subword("inner")<CR>',
  { desc = "Inner Subword" }
)
vim.keymap.set(
  { "o", "x" },
  "U",
  '<cmd>lua require("various-textobjs").url()<CR>',
  { desc = "Url" }
)
vim.keymap.set(
  { "o", "x" },
  "av",
  '<cmd>lua require("various-textobjs").value("outer")<CR>',
  { desc = "A Value" }
)
vim.keymap.set(
  { "o", "x" },
  "iv",
  '<cmd>lua require("various-textobjs").value("inner")<CR>',
  { desc = "Inner Value" }
)
