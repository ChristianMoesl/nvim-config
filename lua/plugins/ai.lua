return {
  {
    "frankroeder/parrot.nvim",
    -- event = "VeryLazy",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      "rcarriga/nvim-notify",
    },
    keys = {
      {
        "<A-u>",
        "<cmd>PrtChatToggle<cr>",
        desc = "Navigate to AI Chat",
      },
    },
    opts = {},
    config = function()
      require("parrot").setup({
        providers = {
          -- anthropic = {
          --   api_key = os.getenv("ANTHROPIC_API_KEY"),
          -- },
          -- gemini = {
          --   api_key = os.getenv("GEMINI_API_KEY"),
          -- },
          openai = {
            api_key = os.getenv("OPENAI_API_KEY"),
          },
        },
      })
    end,
  },
}
