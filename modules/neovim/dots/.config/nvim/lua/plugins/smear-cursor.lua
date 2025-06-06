local M = {
  "sphamba/smear-cursor.nvim",
  version = "*",
}

M.event = { "BufEnter" }

-- Faster smear
-- M.opts = {                              -- Default  Range
--   stiffness = 0.8,                      -- 0.6      [0, 1]
--   trailing_stiffness = 0.5,             -- 0.4      [0, 1]
--   stiffness_insert_mode = 0.6,          -- 0.4      [0, 1]
--   trailing_stiffness_insert_mode = 0.6, -- 0.4      [0, 1]
--   distance_stop_animating = 0.5,        -- 0.1      > 0
-- }

-- No trail smear
M.opts = {
  stiffness = 0.5,
  trailing_stiffness = 0.49,
}

M.config = true

return M
