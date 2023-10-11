return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      cmd = {
        "jdtls",
        "--jvm-arg=-javaagent:/Users/chris/.local/share/nvim/mason/packages/jdtls/lombok.jar",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local gradle_fromatter = {
        method = null_ls.methods.FORMATTING,
        filetypes = { "java" },
        generator = null_ls.formatter({
          command = "gradle",
          args = {
            "spotlessApply",
            "-PspotlessIdeHook=$FILENAME",
            "-PspotlessIdeHookUseStdIn",
            "-PspotlessIdeHookUseStdOut",
            "--no-configuration-cache",
            "--quiet",
          },
          to_stdin = true,
        }),
      }
      opts.sources = vim.list_extend(opts.sources or {}, { gradle_fromatter })
    end,
  },
}