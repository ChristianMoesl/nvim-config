return {
  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
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
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
      servers = {
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeys[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      setup = {},
    },
    config = function(_, opts)
      local mlsp = require("mason-lspconfig")

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        {},
        opts.capabilities or {}
      )

      -- setup autoformat
      require("christianmoesl.core.format").setup(opts)
      -- setup formatting and keymaps
      require("christianmoesl.util").on_attach(function(client, buffer)
        local util = require("christianmoesl.util")
        keymaps = {
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
          { "gi", vim.lsp.buf.implementation, desc = "Goto implementation" },
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
        }

        for _, keys in pairs(keymaps) do
          if not keys.has or util.has(buffer, keys.has) then
            local opts = {
              silent = true,
              buffer = buffer,
              desc = keys.desc,
            }
            vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
          end
        end
      end)

      local servers = opts.servers
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      mlsp.setup({ ensure_installed = { "lua_ls" }, handlers = { setup } })
    end,
  },
  -- formatters
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(
          ".null-ls-root",
          ".neoconf.json",
          "Makefile",
          ".git"
        ),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },
}
