return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- vtsls reports renameProvider = { prepareProvider = true }, so
      -- inc-rename's check_can_rename_at_position() detects prepareRename support
      -- and sends a textDocument/prepareRename request. If vtsls responds with an
      -- error (e.g. tsserver not yet ready, or any other transient issue) inc-rename
      -- feeds <C-c> and tears down the rename window immediately.
      --
      -- Fix: on vtsls attach, flatten renameProvider back to `true` (a boolean).
      -- supports_method("textDocument/prepareRename") then checks
      -- server_capabilities.renameProvider.prepareProvider which is now nil,
      -- the static check fails, no dynamic registration exists, so it returns
      -- false. check_can_rename_at_position() hits the `#clients == 0` early exit
      -- and no prepareRename request is sent — the rename window stays open.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("inc-rename-vtsls-fix", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "vtsls" then
            if type(client.server_capabilities.renameProvider) == "table" then
              client.server_capabilities.renameProvider = true
            end
          end
        end,
      })

      -- Patch vim.glob.to_lpeg to handle invalid glob patterns gracefully.
      -- Some LSP servers (e.g. vtsls) register capabilities with documentSelector
      -- glob patterns that fail validation. Without this, vim.lsp.client._get_registrations
      -- throws inside supports_method, which makes the LSP appear to not support methods
      -- like textDocument/rename, breaking inc-rename and other LSP features.
      -- Patching at the glob level (rather than at supports_method) preserves the correct
      -- capability detection for all methods.
      local original_to_lpeg = vim.glob.to_lpeg
      vim.glob.to_lpeg = function(pattern)
        local ok, result = pcall(original_to_lpeg, pattern)
        if not ok then
          -- Return a pattern that never matches for invalid globs
          return vim.lpeg.P(false)
        end
        return result
      end
    end,
  },
}
