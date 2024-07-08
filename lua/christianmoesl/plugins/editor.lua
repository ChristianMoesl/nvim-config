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
    keys = {
      {
        "<leader>st",
        "<cmd>TodoTelescope<cr>",
        mode = { "n", "v" },
        desc = "Search Todos",
      },
    },
  },
  -- Use gx to open links or references in the browser
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "v" }, desc = "Open identifier under cursor" },
    },
    opts = {
      handlers = {
        jira = {
          name = "jira",
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "%s(%u+-%d+)%s")
            if ticket and #ticket < 20 then
              return "http://jira.redbullmediahouse.com/browse/" .. ticket
            end
          end,
        },
      },
    },
  },
}
