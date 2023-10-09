return {
  "epwalsh/obsidian.nvim",
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/**.md",
    "BufNewFile "
      .. vim.fn.expand("~")
      .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes", -- no need to call 'vim.fn.expand' here
  },
}
