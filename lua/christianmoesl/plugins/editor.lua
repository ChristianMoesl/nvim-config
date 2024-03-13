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
  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  -- Use gx to open links or references in the browser
  {
    "chrishrb/gx.nvim",
    branch = "main",
    event = "VeryLazy",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "v" }, desc = "Open identifier under cursor" },
    },
    opts = {
      handlers = {
        jira = {
          handle = function(mode, line, _)
            local helper = require("gx.helper")
            local pattern = "(%u+-%d+)"
            local ticket = helper.find(line, mode, pattern)
            if ticket and #ticket < 20 then
              return "http://jira.redbullmediahouse.com/browse/" .. ticket
            end
          end,
        },
      },
    },
  },
}
