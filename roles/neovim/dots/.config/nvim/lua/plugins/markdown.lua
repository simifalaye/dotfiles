local function init()
  require("render-markdown").setup({
    render_modes = { "n", "c" },
    -- Characters that will replace the # at the start of headings
    headings = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    -- Character to use for the bullet point in lists
    bullet = "-",
    -- Character that will replace the > at the start of block quotes
    quote = "┃",
    highlights = {
      heading = {
        -- Background of heading line
        backgrounds = { "DiffAdd", "DiffChange", "DiffDelete" },
        -- Foreground of heading character only
        foregrounds = {
          "markdownH1",
          "markdownH2",
          "markdownH3",
          "markdownH4",
          "markdownH5",
          "markdownH6",
        },
      },
      -- Code blocks
      code = "ColorColumn",
      -- Bullet points in list
      bullet = "Comment",
      table = {
        -- Header of a markdown table
        head = "@markup.heading",
        -- Non header rows in a markdown table
        row = "Normal",
      },
      -- LaTeX blocks
      latex = "@markup.math",
      -- Quote character in a block quote
      quote = "@markup.quote",
    },
  })
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Load markdown plugin",
  pattern = { "markdown" },
  once = true,
  callback = function()
    init()
  end,
})
