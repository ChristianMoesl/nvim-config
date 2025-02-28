return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "tsx",
        "typescript",
        "vue",
        "prisma",
      })
    end,
  },
  -- install Vue LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "typescript-language-server",
        "eslint_d",
        "prettier",
        "nxls",
        "vue-language-server",
        "prisma-language-server",
        "vtsls", -- typescript functionality from VsCode
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local servers = {
        prismals = {},
        nxls = {},
        volar = {
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        ts_ls = {
          init_options = {
            plugins = {},
          },
          filetypes = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "vue",
          },
        },
        -- vtsls = { -- not tested
        --   -- explicitly add default filetypes, so that we can extend
        --   -- them in related extras
        --   filetypes = {
        --     "javascript",
        --     "javascriptreact",
        --     "javascript.jsx",
        --     "typescript",
        --     "typescriptreact",
        --     "typescript.tsx",
        --   },
        --   settings = {
        --     complete_function_calls = true,
        --     vtsls = {
        --       enableMoveToFileCodeAction = true,
        --       autoUseWorkspaceTsdk = true,
        --       experimental = {
        --         maxInlayHintLength = 30,
        --         completion = {
        --           enableServerSideFuzzyMatch = true,
        --         },
        --       },
        --     },
        --     typescript = {
        --       updateImportsOnFileMove = { enabled = "always" },
        --       suggest = {
        --         completeFunctionCalls = true,
        --       },
        --       inlayHints = {
        --         enumMemberValues = { enabled = true },
        --         functionLikeReturnTypes = { enabled = true },
        --         parameterNames = { enabled = "literals" },
        --         parameterTypes = { enabled = true },
        --         propertyDeclarationTypes = { enabled = true },
        --         variableTypes = { enabled = false },
        --       },
        --     },
        --   },
        -- },
      }
      opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, servers)

      local mason_registry = require("mason-registry")
      local has_volar, volar = pcall(mason_registry.get_package, "vue-language-server")

      -- If server `volar` and `ts_ls` exists, add `@vue/typescript-plugin` to `ts_ls`
      if opts.servers.volar ~= nil and opts.servers.ts_ls ~= nil and has_volar then
        local ts_ls = opts.servers.ts_ls or {} -- Ensure ts_ls is initialized
        ts_ls.init_options = ts_ls.init_options or {} -- Ensure init_options is initialized
        ts_ls.init_options.plugins = ts_ls.init_options.plugins or {} -- Ensure plugins is initialized

        local vue_ts_plugin_path = volar:get_install_path()
          .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"

        local vue_plugin = {
          name = "@vue/typescript-plugin",
          -- Maybe a function to get the location of the plugin is better?
          -- e.g. pnpm fallback to nvm fallback to default node path
          location = vue_ts_plugin_path,
          languages = { "vue" },
        }

        -- Append the plugin to the `ts_ls` server
        vim.list_extend(ts_ls.init_options.plugins, { vue_plugin })

        opts.servers.ts_ls = ts_ls
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
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-vitest"))
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npx jest",
          -- jestConfigFile = "custom.jest.config.ts",

          jestConfigFile = "/Users/Christian.Moesl/Workspace/rbcp-newseditor/libs/shared/sparkle-sqs/jest.config.js",

          -- jestConfigFile = function(file)
          --   if string.find(file, "/packages/") then
          --     return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
          --   end
          --
          --   return vim.fn.getcwd() .. "/jest.config.ts"
          -- end,
          env = { CI = true },
          cwd = function(_) return vim.fn.getcwd() end,
        })
      )
    end,
  },
  {
    "pipoprods/nvm.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    config = true,
  },
}
