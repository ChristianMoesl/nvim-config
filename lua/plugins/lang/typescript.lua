return {
  { "ChristianMoesl/neotest-vitest", branch = "main" },
  -- Bump tsserver memory for large monorepos (e.g. rb3ca-rb3 has ~6500 TS files).
  -- Default is 3072 MB which causes tsserver to OOM-crash on this codebase.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- Treesitter indent for TypeScript is buggy and produces wrong indentation
      -- on new lines. Disabling it makes Neovim fall back to LSP indentation.
      indent = {
        enable = true,
        disable = { "typescript", "tsx" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "ChristianMoesl/neotest-vitest",
    },
    opts = {
      adapters = {
        "neotest-vitest",
      },
    },
  },
}
