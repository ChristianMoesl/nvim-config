-- https://biomejs.dev/internals/language-support/
local supported = {
  "scss",
}

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "stylelint" } },
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- stylelint-lsp will be automatically installed with mason and loaded with lspconfig
        stylelint_lsp = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "stylelint")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.stylelint = {
        require_cwd = true,
      }
    end,
  },
}
