local notes_directory_expanded = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes"
local notes_directory = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes"

---@param name string
local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

if file_exists(vim.fn.expand("~") .. "/Notes/ToDos.md") then
  notes_directory_expanded = vim.fn.expand("~") .. "/Notes"
  notes_directory = "~/Notes"
end

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    -- ft = "markdown",
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
        .. notes_directory
        .. "/**.md",
      "BufNewFile " .. notes_directory .. "/**.md",
    },
    keys = {
      {
        "<leader>T",
        function()
          vim.cmd("e " .. notes_directory .. "/ToDos.md")
        end,
        desc = "ToDos",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return {
        workspaces = {
          {
            name = "workspace",
            path = notes_directory,
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fn",
        function()
          require("telescope.builtin").find_files({ cwd = notes_directory_expanded })
        end,
        desc = "Notes",
      },
    },
  },
}
