return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  cond = require("christianmoesl.util").is_full_profile,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  events = "VeryLazy",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = vim.loop.cwd(),
        })
      end,
      desc = "Explorer NeoTree",
    },
  },
  opts = {
    filesystem = {
      group_empty_dirs = true,
      scan_mode = "deep",
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
      },
    },
  },
}
