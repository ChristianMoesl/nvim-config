return {
  {
    "numToStr/Comment.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    event = "VeryLazy",
    opts = {},
  },
  -- plugin to detect indentation width automatically
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    cond = require("christianmoesl.util").is_full_profile,
    opts = {},
  },
}
