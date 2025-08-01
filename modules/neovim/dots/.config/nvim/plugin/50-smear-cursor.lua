local deps = require("mini.deps")

deps.add({
  source = "sphamba/smear-cursor.nvim",
})

deps.later(function()
  local fast_smear_opts = {
    stiffness = 0.8,                      -- 0.6      [0, 1]
    trailing_stiffness = 0.5,             -- 0.4      [0, 1]
    stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
    trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
    damping = 0.8,                        -- 0.65     [0, 1]
    damping_insert_mode = 0.8,            -- 0.7      [0, 1]
    distance_stop_animating = 0.5,        -- 0.1      > 0
  }
  -- local smooth_no_smear = {
  --   stiffness = 0.5,
  --   trailing_stiffness = 0.5,
  --   damping = 0.67,
  --   matrix_pixel_threshold = 0.5,
  -- }
  require("smear_cursor").setup(fast_smear_opts)
end)
