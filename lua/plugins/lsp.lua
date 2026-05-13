return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- Patch vim.lsp.client.supports_method to catch and suppress glob errors
      local client_module = require("vim.lsp.client")
      local original_supports_method = client_module.supports_method
      
      client_module.supports_method = function(self, method, opts)
        local ok, result = pcall(original_supports_method, self, method, opts)
        if not ok then
          -- Return false instead of crashing on glob validation errors
          return false
        end
        return result or false
      end
    end,
  },
}
