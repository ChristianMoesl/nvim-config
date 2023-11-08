return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = { name = "+harpoon" },
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>ha",
        "<cmd>lua require('harpoon.mark').add_file()<cr>",
        desc = "Mark file with harpoon",
      },
      {
        "<leader>ho",
        "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
        desc = "Show harpoon marks",
      },
      {
        "<A-h>",
        "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
        desc = "Navigate to file 1",
      },
      {
        "<A-j>",
        "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
        desc = "Navigate to file 2",
      },
      {
        "<A-k>",
        "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
        desc = "Navigate to file 3",
      },
      {
        "<A-l>",
        "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
        desc = "Navigate to file 4",
      },
      {
        "<A-;>",
        "<cmd>lua require('harpoon.term').gotoTerminal(1)<cr>",
        desc = "Navigate to terminal 1",
      },
      {
        "<A-'>",
        "<cmd>lua require('harpoon.term').gotoTerminal(2)<cr>",
        desc = "Navigate to terminal 2",
      },
    },
    opts = {
      menu = {
        width = 120,
      },
    },
  },
}
