return {
  -- formatters
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cond = require("christianmoesl.util").is_full_profile,
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>uf",
        function()
          if vim.g.disable_autoformat then
            vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Format" })
            vim.g.disable_autoformat = false
          else
            vim.notify("Disabled format on save", vim.log.levels.INFO, { title = "Format" })
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
        timeout_ms = 3000,
      },
      formatters_by_ft = {
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
      },
      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return { timeout_ms = 3000, lsp_fallback = true }
      end,
    },
  },
}
