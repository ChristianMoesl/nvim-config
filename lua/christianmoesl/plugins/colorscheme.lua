return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      integrations = {
        alpha = true,
        cmp = false,
        flash = false,
        gitsigns = false,
        illuminate = false,
        indent_blankline = { enabled = true },
        lsp_trouble = false,
        mason = false,
        mini = false,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = false, custom_bg = "lualine" },
        neotest = false,
        noice = false,
        notify = false,
        neotree = true,
        semantic_tokens = false,
        telescope = false,
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)

      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
  },
}
