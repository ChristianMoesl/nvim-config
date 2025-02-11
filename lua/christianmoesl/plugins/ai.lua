return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      -- It is recommended to disable copilot.lua's suggestion and panel modules,
      -- as they can interfere with completions properly appearing in copilot-cmp
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts) require("copilot").setup(opts) end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)

      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "copilot" then
            copilot_cmp._on_insert_enter({})
          end
        end,
      })
    end,
  },
  {
    "frankroeder/parrot.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
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
  -- {
  --   "robitx/gp.nvim",
  --   event = "VeryLazy",
  --   cond = require("christianmoesl.util").is_full_profile,
  --   -- keys = {
  --   --   {
  --   --     "<A-u>",
  --   --     function()
  --   --       local name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  --   --       if name:find("^" .. vim.fn.stdpath("data") .. "/gp/chats/.*%.md$") ~= nil then
  --   --         -- don't try to open buffer if it is already displayed
  --   --         return
  --   --       end
  --   --       local window = vim.api.nvim_get_current_win()
  --   --       vim.cmd("GpChatToggle")
  --   --       vim.api.nvim_win_close(window, false)
  --   --     end,
  --   --     desc = "Navigate to ChatGPT",
  --   --   },
  --   -- },
  --   config = function()
  --     require("gp").setup({
  --       openai_api_key = os.getenv("OPENAI_API_KEY"),
  --     })
  --   end,
  -- },
}
