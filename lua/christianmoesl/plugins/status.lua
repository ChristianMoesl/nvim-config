return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  cond = require("christianmoesl.util").is_full_profile,
  opts = {
    extensions = {
      "neo-tree",
      "lazy",
      "fugitive",
      "quickfix",
      "nvim-dap-ui",
    },
  },
}
