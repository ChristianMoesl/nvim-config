return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },
  -- install formatter and Java LSP server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "jdtls",
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
    dependencies = { "folke/which-key.nvim" },
    ft = { "java" },
    opts = {
      cmd = {
        "jdtls",
        "--jvm-arg=-javaagent:/Users/chris/.local/share/nvim/mason/packages/jdtls/lombok.jar",
      },
    },
    config = function(_, opts)
      local function attach_jdtls()
        local root_dir =
          require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

        local project_name = root_dir and vim.fs.basename(root_dir)

        if project_name then
          -- Where are the config and workspace dirs for a project?
          local jdtls_config_dir = vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. project_name
            .. "/config"
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
        opts.capabilities = vim.tbl_deep_extend(
          "force",
          opts.capabilities or {},
          require("cmp_nvim_lsp").default_capabilities()
        )

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(opts)
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
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
          -- This can be a string or a function that returns a string
          command = vim.fn.expand("~") .. "/.config/nvim/spotless.sh",
          -- OPTIONAL - all fields below this are optional
          -- A list of strings, or a function that returns a list of strings
          -- Return a single string instead to run the command in a shell
          -- args = { "--stdin-from-filename", "$FILENAME" },
          args = {
            "$FILENAME",
          },
          -- If the formatter supports range formatting, create the range arguments here
          -- range_args = function(ctx)
          --   return {
          --     "--line-start",
          --     ctx.range.start[1],
          --     "--line-end",
          --     ctx.range["end"][1],
          --   }
          -- end,
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
  {
    "nvim-neotest/neotest",
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
    },
  },
}
