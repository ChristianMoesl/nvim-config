return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
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
