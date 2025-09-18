return {
  -- Install Jsonnet treesitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "jsonnet" } },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "jsonnet-language-server")
    end,
  },
  -- Configure Jsonnet language server
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonnet_ls = {},
      },
    },
  },
}
