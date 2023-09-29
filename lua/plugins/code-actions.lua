return {
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
      table.insert(opts.sources, gradle_fromatter)
    end,
  },
}
