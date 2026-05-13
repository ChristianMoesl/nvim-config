-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ESLint autofix on save.
-- LazyVim's linting.eslint extra relies on textDocument/formatting, which ESLint does not
-- advertise. The native nvim-lspconfig eslint config (Nvim 0.11+) only exposes
-- LspEslintFixAll (workspace/executeCommand), so we wire that up manually here.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("eslint_fix_all", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function(ev)
          if LazyVim.format.enabled(ev.buf) then
            vim.cmd("LspEslintFixAll")
          end
        end,
      })
    end
  end,
})
