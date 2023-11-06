return {
  {
    "echasnovski/mini.statusline",
    version = "*",
    lazy = false,
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        content = {
          active = function()
            -- stylua: ignore start
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local spell         = vim.wo.spell and (statusline.is_truncated(120) and 'S' or 'SPELL') or ''
            local wrap          = vim.wo.wrap and (statusline.is_truncated(120) and 'W' or 'WRAP') or ''
            local macro         = vim.fn.reg_recording() ~= "" and ("@" .. vim.fn.reg_recording()) or ""
            local git           = statusline.section_git({ trunc_width = 75 })
            -- Default diagnstics icon has some problems displaying in Kitty terminal
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            -- local searchcount   = statusline.section_searchcount({ trunc_width = 75 })
            local location      = statusline.section_location({ trunc_width = 10000 })

            -- Usage of `statusline.combine_groups()` ensures highlighting and
            -- correct padding with spaces between groups (accounts for 'missing'
            -- sections, etc.)
            return statusline.combine_groups({
              { hl = mode_hl,                 strings = { mode, spell, wrap, macro } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { --[[searchcount,]] location } },
            })
            -- stylua: ignore end
          end,
        },
      })
    end,
  },
}
