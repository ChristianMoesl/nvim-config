return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts) require("copilot").setup(opts) end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "zbirenbaum/copilot.lua",
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)

      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "copilot" then
            copilot_cmp._on_insert_enter({})
          end
        end,
      })
    end,
  },
}
