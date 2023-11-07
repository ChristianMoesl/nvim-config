return {
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "numToStr/Comment.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    event = "VeryLazy",
    opts = {},
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {},
  },
  -- scope markers based on indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          "dashboard",
        },
      },
    },
  },
  -- plugin to detect indentation width automatically
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    cond = require("christianmoesl.util").is_full_profile,
    opts = {},
  },
}
