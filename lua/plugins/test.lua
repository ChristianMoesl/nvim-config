return {
  { "andy-bell101/neotest-java" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    opts = {
      adapters = { "neotest-java" },
    },
  },
}
