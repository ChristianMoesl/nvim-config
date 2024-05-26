return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    keys = {},
    config = function()
      local lint = require("lint")
      print(vim.inspect(lint.linters_by_ft))
      local group = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
