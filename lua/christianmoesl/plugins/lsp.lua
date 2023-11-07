local function map_lsp_keys(client, buffer)
  local util = require("christianmoesl.util")
  local keymaps = {
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    { "K", vim.lsp.buf.hover, desc = "Hover" },
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
      "gi",
      vim.lsp.buf.implementation,
      desc = "Goto implementation",
    },
    {
      "gd",
      function()
        require("telescope.builtin").lsp_definitions({ reuse_win = true })
      end,
      desc = "Goto Definition",
      has = "definition",
    },
    {
      "sr",
      function() require("telescope.builtin").lsp_references() end,
      desc = "References",
    },
    { "]d", util.diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[d", util.diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]e", util.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
    { "[e", util.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
    { "]w", util.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
    { "[w", util.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
    {
      "<leader>ca",
      vim.lsp.buf.code_action,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  }

  for _, keys in pairs(keymaps) do
    if not keys.has or util.has(buffer, keys.has) then
      local keys_opts = {
        silent = true,
        buffer = buffer,
        desc = keys.desc,
      }
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], keys_opts)
    end
  end
end

return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    cond = require("christianmoesl.util").is_full_profile,
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "codespell",
        "shellcheck",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      mr.refresh(ensure_installed)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
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
      ---@type lspconfig.options
      servers = {},
      setup = {},
    },
    config = function(_, opts)
      -- setup formatting and keymaps
      require("christianmoesl.util").on_attach(map_lsp_keys)

      for server, _ in pairs(opts.servers) do
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(opts.capabilities),
        }, opts.servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end
    end,
  },
}
