local Util = require("lazy.core.util")

return {
  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>uf",
        function()
          if vim.g.disable_autoformat then
            Util.info("Enabled format on save", { title = "Format" })
            vim.g.disable_autoformat = false
          else
            Util.info("Disabled format on save", { title = "Format" })
            vim.g.disable_autoformat = true
          end
        end,
        desc = "Toggle format on Save",
      },
      {
        "<leader>cf",
        function() require("conform").format({ lsp_fallback = true }) end,
        mode = "",
        desc = "Format",
      },
    },
    opts = {
      format = {
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        ["sh"] = { "shfmt" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 10000, lsp_fallback = true }
      end,
    },
  },
}
