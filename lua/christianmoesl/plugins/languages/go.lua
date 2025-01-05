return {
  -- Ensure Go tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(
        opts.ensure_installed or {},
        { "gopls", "goimports", "gofumpt", "delve", "golangci-lint" }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "go",
        "gomod",
        "gowork",
        "gosum",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          filetypes = {
            "go",
            "gomod",
            "gowork",
            -- "gojs",
          },
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            {
              "<leader>td",
              "<cmd>lua require('dap-go').debug_test()<CR>",
              desc = "Debug Nearest (Go)",
            },
          },
          settings = {
            gopls = {
              gofumpt = true,
              templateExtensions = {
                "gojs",
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = {
                "-.git",
                "-.vscode",
                "-.idea",
                "-.vscode-test",
                "-node_modules",
              },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    -- ft = { "go" },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang",
        -- version = "*",
        dependencies = {
          "leoluz/nvim-dap-go",
        },
      },
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-golang"))
    end,
  },
  -- {
  --   -- "leoluz/nvim-dap-go",
  --   -- ft = { "go" },
  --   config = function() require("dap-go").setup() end,
  -- },
  -- Configure linter
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        go = { "golangcilint" },
      })
    end,
  },
  -- Configure formatter
  {
    "stevearc/conform.nvim",
    opts = function(_, opts) opts.formatters_by_ft.go = { "goimports", "gofumpt" } end,
  },
}
