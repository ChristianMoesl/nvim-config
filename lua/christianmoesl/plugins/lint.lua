return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    cond = require("christianmoesl.util").is_full_profile,
    config = function()
      local lint = require("lint")
      local group = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
