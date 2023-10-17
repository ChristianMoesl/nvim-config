local function builtin() return require("telescope.builtin") end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      {
        "<leader>,",
        function() builtin().buffers({ show_all_buffers = true }) end,
        desc = "Switch Buffer",
      },
      {
        "<leader>/",
        function() builtin().live_grep() end,
        desc = "Grep (root dir)",
      },
      {
        "<leader>:",
        function() builtin().command_history() end,
        desc = "Command History",
      },
      -- find
      {
        "<leader>ff",
        function() builtin().find_files({}) end,
        desc = "Find Files",
      },
      {
        "<leader>fr",
        function() builtin().oldfiles() end,
        desc = "Recent Files",
      },
      -- git
      {
        "<leader>gc",
        function() builtin().git_commits() end,
        desc = "commits",
      },
      {
        "<leader>gs",
        function() builtin().git_status() end,
        desc = "status",
      },
      -- search
      {
        '<leader>s"',
        function() builtin().registers() end,
        desc = "Registers",
      },
      {
        "<leader>sa",
        function() builtin().autocommands() end,
        desc = "Auto Commands",
      },
      {
        "<leader>sb",
        function() builtin().current_buffer_fuzzy_find() end,
        desc = "Buffer",
      },
      {
        "<leader>sc",
        function() builtin().command_history() end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function() builtin().commands() end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function() builtin().diagnostics({ bufnr = 0 }) end,
        desc = "Document diagnostics",
      },
      {
        "<leader>sD",
        function()
          builtin().diagnostics({ root_dir = vim.fn.getcwd() .. "/src" })
        end,
        desc = "Workspace diagnostics",
      },
      {
        "<leader>sr",
        function() builtin().lsp_references() end,
        desc = "Code References",
      },
    },
    opts = {},
    config = function(_, opts)
      local actions = require("telescope.actions")
      local defaults = {
        mappings = {
          i = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<M-q>"] = false,
          },
          n = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<M-q>"] = false,
          },
        },
      }
      opts.defaults =
        vim.tbl_deep_extend("force", opts.defaults or {}, defaults)

      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
    end,
  },
  -- {
  --   "folke/trouble.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "n",
  --       "gR",
  --       function() require("trouble").toggle("lsp_references") end,
  --       desc = "Goto References",
  --     },
  --   },
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  -- },
}
