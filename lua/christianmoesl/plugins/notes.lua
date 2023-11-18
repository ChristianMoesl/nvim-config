local notes_directory = vim.fn.expand("~")
  .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes"

return {
  {
    "epwalsh/obsidian.nvim",
    cond = require("christianmoesl.util").is_full_profile,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
        .. notes_directory
        .. "/**.md",
      "BufNewFile " .. notes_directory .. "/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes", -- no need to call 'vim.fn.expand' here
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>sn",
        function() require("telescope.builtin").find_files({ cwd = notes_directory }) end,
        desc = "Notes",
      },
    },
  },
}
