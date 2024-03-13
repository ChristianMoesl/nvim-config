return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java", "groovy", "kotlin" })
    end,
  },
  -- install formatter and Java LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "jdtls",
        "java-test", -- build from source instead of installing it with Mason: https://github.com/mason-org/mason-registry/pull/3083
        "java-debug-adapter",
        "sonarlint-language-server",
      })
    end,
  },
  -- defer actually starting it to our configuration of nvim-jtdls below.
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  -- Set up nvim-jdtls to attach to java files.
  {
    "mfussenegger/nvim-jdtls",
    branch = "master",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      "folke/which-key.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    ft = { "java" },
    ---@type lsp.StartOpts
    opts = {
      flags = {
        debounce_text_changes = 300, -- default is 150
      },
      cmd = {
        "jdtls",
        string.format(
          -- TODO: remove this workaround (currently we need to patch lombok with the latest edge version to make it work)
          "--jvm-arg=-javaagent:%s/mason/share/jdtls/lombok-edge.jar",
          vim.fn.stdpath("data")
        ),
        "--jvm-arg=-Xmx8G", -- give some additional memory for large projects
      },
      settings = {
        java = {
          autobuild = { enabled = true },
          maxConcurrentBuilds = 1,
          signatureHelp = { enabled = true },
          import = { enabled = true },
          rename = { enabled = true },
          implementationsCodeLens = { enabled = true },
          referencesCodeLens = { enabled = true },
          references = {
            includeDecompiledSources = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all", -- literals, all, none
            },
          },
          jdt = {
            ls = {
              lombokSupport = { enabled = true },
            },
          },
          completion = {
            favoriteStaticMembers = {
              "org.assertj.core.api.Assertions.assertThat",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "java.awt.*",
              "com.sun.*",
              "io.micrometer.shaded.*",
            },
            matchCase = "FIRSTLETTER",
          },
          edit = {
            validateAllOpenBuffersOnChanges = true,
          },
        },
      },
      -- handlers = {
      --   ["language/status"] = function(_, _)
      --     -- print(result)
      --   end,
      --   ["$/progress"] = function(_, _, _)
      --     -- disable progress updates.
      --   end,
      -- },
    },
    config = function(_, opts)
      local function attach_jdtls()
        local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

        local project_name = root_dir and vim.fs.basename(root_dir)

        if project_name then
          -- Where are the config and workspace dirs for a project?
          local jdtls_config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
          local jdtls_workspace_dir = vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. project_name
            .. "/workspace"

          vim.list_extend(opts.cmd, {
            "-configuration",
            jdtls_config_dir,
            "-data",
            jdtls_workspace_dir,
          })
        end

        -- enable CMP capabilities
        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities({
          snippetSupport = false,
        })
        opts.capabilities =
          vim.tbl_deep_extend("force", opts.capabilities, lsp_capabilities, cmp_capabilities)

        -- Find the extra bundles that should be passed on the jdtls command-line
        -- if nvim-dap is enabled with java debug/test.
        local mason_registry = require("mason-registry")
        opts.init_options = {
          bundles = {}, ---@type string[]
        }
        local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
        local java_dbg_path = java_dbg_pkg:get_install_path()
        local jar_patterns = {
          java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        }

        -- java-test also depends on java-debug-adapter.
        local java_test_pkg = mason_registry.get_package("java-test")
        local java_test_path = java_test_pkg:get_install_path()
        vim.list_extend(jar_patterns, {
          java_test_path .. "/extension/server/*.jar",
        })

        for _, jar_pattern in ipairs(jar_patterns) do
          for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
            table.insert(opts.init_options.bundles, bundle)
          end
        end

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(opts)
        require("jdtls").setup_dap(opts.dap)
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
      })

      -- Setup keymap and dap after the lsp is fully attached.
      -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      -- https://neovim.io/doc/user/lsp.html#LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil or client.name ~= "jdtls" then
            return
          end
          vim.keymap.set(
            "n",
            "<leader>tf",
            function() require("jdtls").test_class() end,
            { desc = "Test File" }
          )
          vim.keymap.set(
            "n",
            "<leader>tn",
            function() require("jdtls").test_nearest_method() end,
            { desc = "Test Nearest Method" }
          )
          vim.keymap.set(
            "n",
            "<leader>cw",
            function() require("jdtls.setup").wipe_data_and_restart() end,
            { desc = "Wipe and restart LSP" }
          )
        end,
      })

      attach_jdtls()
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.java = { "spotless" }
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
        spotless = {
          -- don't merge with default config
          inherit = false,
          -- This can be a string or a function that returns a string
          command = vim.fn.stdpath("config") .. "/spotless.sh",
          args = {
            "$FILENAME",
          },
          -- Send file contents to stdin, read new contents from stdout (default true)
          -- When false, will create a temp file (will appear in "$FILENAME" args). The temp
          -- file is assumed to be modified in-place by the format command.
          stdin = true,
          -- A function that calculates the directory to run the command in
          cwd = require("conform.util").root_file({
            "gradlew",
          }),
          -- When cwd is not found, don't run the formatter (default false)
          -- require_cwd = true,
          -- When returns false, the formatter will not be used
          ---@param ctx conform.Context
          -- condition = function(ctx)
          --   return true
          -- return vim.fs.basename(ctx.filename) ~= ".java"
          -- end,
          -- Exit codes that indicate success (default {0})
          -- exit_codes = { 0, 1 },
          -- Environment variables. This can also be a function that returns a table.
          -- env = {
          --   VAR = "value",
          -- },
        },
      })
    end,
  },
}
