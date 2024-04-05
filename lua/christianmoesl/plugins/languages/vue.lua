return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "vue",
      })
    end,
  },
  -- install Vue LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "vue-language-server",
        "prettier",
        "typescript-language-server",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = {
        volar = {
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        tsserver = {
          init_options = {
            plugins = {},
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },
      }
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, servers)

      local mason_registry = require("mason-registry")
      local has_volar, volar = pcall(mason_registry.get_package, "vue-language-server")

      -- If server `volar` and `tsserver` exists, add `@vue/typescript-plugin` to `tsserver`
      if opts.servers.volar ~= nil and opts.servers.tsserver ~= nil and has_volar then
        local tsserver = opts.servers.tsserver or {} -- Ensure tsserver is initialized
        tsserver.init_options = tsserver.init_options or {} -- Ensure init_options is initialized
        tsserver.init_options.plugins = tsserver.init_options.plugins or {} -- Ensure plugins is initialized

        -- Even for now can use
        local vue_ts_plugin_path = volar:get_install_path()
          .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
        -- after volar 2.0.7
        -- local vue_ts_plugin_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/typescript-plugin'

        local vue_plugin = {
          name = "@vue/typescript-plugin",
          -- Maybe a function to get the location of the plugin is better?
          -- e.g. pnpm fallback to nvm fallback to default node path
          location = vue_ts_plugin_path,
          languages = { "vue" },
        }

        -- Append the plugin to the `tsserver` server
        vim.list_extend(tsserver.init_options.plugins, { vue_plugin })

        opts.servers.tsserver = tsserver
      end
    end,
  },
  -- formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = function(_, opts)
      if opts.adapters == nil then
        opts.adapters = {}
      end
      table.insert(opts.adapters, require("neotest-vitest"))
    end,
  },
}
