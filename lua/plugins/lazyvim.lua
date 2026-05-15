-- TODO: fix floating terminal keymappings and harpoon interference
return {
  -- disable Snacks file explorer (replaced by Oil)
  {
    "folke/snacks.nvim",
    keys = {
      -- Disable these keymaps (replaced by Oil keymaps)
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },
    },
    opts = {
      explorer = { enabled = false },
      picker = {
        win = {
          preview = {
            wo = {
              wrap = true,
            },
          },
        },
      },
    },
  },
  -- disable Trouble (use quickfix list instead)
  { "folke/trouble.nvim", enabled = false },
  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo" },
      {
        "<leader>xT",
        "<cmd>TodoQuickFix keywords=TODO,FIX,FIXME<cr>",
        desc = "Todo/Fix/Fixme",
      },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  -- disable buffer status bar at the top
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "lewis6991/async.nvim",
    },
    keys = {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "x" } },
      {
        "<leader>rs",
        function()
          return require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Refactor",
      },
      {
        "<leader>ri",
        function()
          return require("refactoring").inline_var()
        end,
        mode = { "n", "x" },
        desc = "Inline Variable",
        expr = true,
      },
      {
        "<leader>rI",
        function()
          return require("refactoring").inline_func()
        end,
        mode = { "n", "x" },
        desc = "Inline Function",
        expr = true,
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").extract_func()
        end,
        mode = { "n", "x" },
        desc = "Extract Function",
        expr = true,
      },
      {
        "<leader>rF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        mode = { "n", "x" },
        desc = "Extract Function To File",
        expr = true,
      },
      {
        "<leader>rx",
        function()
          return require("refactoring").extract_var()
        end,
        mode = { "n", "x" },
        desc = "Extract Variable",
        expr = true,
      },
      {
        "<leader>rp",
        function()
          return require("refactoring.debug").print_var({ output_location = "below" })
        end,
        mode = { "n", "x" },
        desc = "Debug Print Variable",
        expr = true,
      },
      {
        "<leader>rP",
        function()
          return require("refactoring.debug").print_loc({ output_location = "below" })
        end,
        desc = "Debug Print Location",
        expr = true,
      },
      {
        "<leader>rc",
        function()
          return require("refactoring.debug").cleanup({ restore_view = true })
        end,
        mode = { "n", "x" },
        desc = "Debug Cleanup",
        expr = true,
      },
    },
    opts = {},
  },
  { "folke/tokyonight.nvim", enabled = false },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = vim.list_extend(opts.spec or {}, {
        { "<leader>cg", group = "Generate" },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Override LazyVim keymaps
      {
        "<leader>sG",
        function()
          local cwd = require("lib.files").find_local_project_root()
          LazyVim.pick("live_grep", { cwd = cwd })()
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>si",
        function()
          require("telescope.builtin").lsp_incoming_calls()
        end,
        desc = "Search Incoming Calls",
      },
    },
    opts = {
      defaults = {
        layout_strategy = "vertical",
        -- ignored files are described in ~/.rgignore
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden", -- also search hidden files
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Disable markdown linter because it's kind of awnoying
      opts.linters_by_ft["markdown"] = nil
    end,
  },
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      -- Disable opening of quickfix list when tests fail
      opts.quickfix.open = function() end
    end,
  },
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.custom_textobjects.k = ai.gen_spec.treesitter({ a = "@comment.outer", i = "@comment.inner" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },
}
