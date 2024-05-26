return {
  -- install treesitter grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "kotlin" })
    end,
  },
  -- install formatter and Linter, Formatter, and LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "ktlint",
        "kotlin-language-server",
      })
    end,
  },
  -- configure LSP server
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "pysan3/pathlib.nvim",
    },
    opts = function(_, opts)
      local servers = {
        kotlin_language_server = {
          init_options = {
            storagePath = vim.fn.stdpath("data"),
          },
        },
      }
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, servers)
    end,
  },
  -- configure Formatter integration
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.formatters_by_ft.kotlin = { "ktlint" } end,
  },
}
