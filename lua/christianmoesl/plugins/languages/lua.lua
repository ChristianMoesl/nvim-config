return {
  -- install formatter and Lua LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "lua-language-server",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.formatting.stylua,
      })
    end,
  },
}
