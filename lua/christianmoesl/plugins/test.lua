local file_types = { "go", "javascript", "typescript" }
return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults = vim.list_extend(opts.defaults or {}, {
        { "<leader>t", group = "test" },
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
    },
    config = function(_, opts) require("neotest").setup(opts) end,
    -- stylua: ignore
    keys = {
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, ft = file_types, desc = "Run File" },
      { "<leader>tF", function() require("neotest").run.run(vim.loop.cwd()) end, ft = file_types, desc = "Run All Test Files" },
      { "<leader>tn", function() require("neotest").run.run()end , ft = file_types, desc = "Run Nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, ft = file_types, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, ft = file_types, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, ft = file_types, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, ft = file_types, desc = "Stop" },
    },
  },
}
