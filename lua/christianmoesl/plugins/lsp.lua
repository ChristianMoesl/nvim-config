---@param buffer integer
---@param method string
local function has_method(buffer, method)
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---@param next boolean next or previous
---@param severity string|nil diagnostic severity
local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  return function() go({ severity = severity and vim.diagnostic.severity[severity] or nil }) end
end

---@param buffer integer
---@param client vim.lsp.Client|nil
local function map_lsp_keys(buffer, client)
  local keymaps = {
    { "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
    {
      "gK",
      vim.lsp.buf.signature_help,
      desc = "Signature Help",
      has = "signatureHelp",
    },
    {
      "<c-k>",
      vim.lsp.buf.signature_help,
      mode = "i",
      desc = "Signature Help",
      has = "signatureHelp",
    },
    {
      "gI",
      vim.lsp.buf.implementation,
      desc = "Goto implementation",
    },
    {
      "gd",
      function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
      desc = "Goto Definition",
      has = "definition",
    },
    {
      "gD",
      function() vim.lsp.buf.declaration() end,
      desc = "Goto Declaration",
    },
    {
      "gt",
      function() require("telescope.builtin").lsp_type_definitions() end,
      desc = "Type Definition",
    },
    {
      "<leader>ss",
      function() require("telescope.builtin").lsp_document_symbols() end,
      desc = "Document Symbols",
    },
    {
      "<leader>sS",
      function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end,
      desc = "Workspace Symbols",
    },
    {
      "sr",
      function() require("telescope.builtin").lsp_references() end,
      desc = "References",
    },
    { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    {
      "<leader>ca",
      vim.lsp.buf.code_action,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    { "<leader>cR", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
  }

  for _, keys in pairs(keymaps) do
    if not keys.has or has_method(buffer, keys.has) then
      local keys_opts = {
        silent = true,
        buffer = buffer,
        desc = keys.desc,
      }
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], keys_opts)
    end
  end

  -- The following two autocommands are used to highlight references of the
  -- word under your cursor when your cursor rests there for a little while.
  --    See `:help CursorHold` for information about when this is executed
  --
  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = buffer,
    callback = function()
      if client and client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.document_highlight()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = buffer,
    callback = function()
      if client and client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.clear_references()
      end
    end,
  })
end

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    cond = require("christianmoesl.util").is_full_profile,
    build = ":MasonUpdate",
    opts = {
      -- add any tools you want to have installed below
      ensure_installed = {
        "codespell",
        "shellcheck",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local registry = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local package = registry.get_package(tool)
          if not package:is_installed() then
            package:install()
          end
        end
      end
      registry.refresh(ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      "mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      inlay_hints = { enabled = true },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- add any global capabilities here
      capabilities = {},
      autoformat = true,
      -- LSP Server Settings
      servers = {},
      setup = {},
    },
    config = function(_, opts)
      -- setup formatting and keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          map_lsp_keys(event.buf, client)
        end,
      })

      -- enable CMP capabilities
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
      local capabilities =
        vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities, opts.capabilities)

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      for server, _ in pairs(opts.servers) do
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, opts.servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end
    end,
  },
}
