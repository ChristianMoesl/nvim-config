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
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
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
        "<leader>/",
        LazyVim.pick("live_grep", { root = false }),
        -- require("telescope.builtin").find_files({ hidden = true, no_ignore = true, no_ignore_parent = true })
        desc = "Find Files (including hidden)",
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
}
