-- TODO: fix floating terminal keymappings and harpoon interference
return {
  -- disable Snacks file explorer (replaced by Oil)
  {
    "folke/snacks.nvim",
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
}
