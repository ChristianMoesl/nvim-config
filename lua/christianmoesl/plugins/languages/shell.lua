return {
  -- install treesitter grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "bash" })
    end,
  },
  -- install formatter and Linter, Formatter, and LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "shfmt",
      })
    end,
  },
  -- Configure linter
  {
    "mfussenegger/nvim-lint",
    opts = function()
      local lint = require("lint")
      lint.linters_by_ft = vim.tbl_deep_extend("force", lint.linters_by_ft or {}, {
        sh = { "shellcheck" },
      })
    end,
  },
  -- configure Formatter integration
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["sh"] = { "shfmt" },
        ["zsh"] = { "shfmt" },
      },
    },
  },
}
