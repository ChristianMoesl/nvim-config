return {
  {
    "numToStr/Comment.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    event = "VeryLazy",
    opts = {},
  },
  -- scope markers based on indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    cond = false, -- require("christianmoesl.util").is_full_profile,
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          "dashboard",
        },
      },
    },
  },
  -- plugin to detect indentation width automatically
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    cond = require("christianmoesl.util").is_full_profile,
    opts = {},
  },
}
