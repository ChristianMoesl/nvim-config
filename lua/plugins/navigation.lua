local terminals = {}

-- @param num number
local function open_terminal(num)
  local curr_bufnr = terminals[num]
  if curr_bufnr and vim.api.nvim_buf_is_valid(curr_bufnr) then
    vim.api.nvim_win_set_buf(0, curr_bufnr)
  else
    vim.cmd(":terminal")
    local bufnr = vim.api.nvim_get_current_buf()
    print("Terminal " .. num .. " opened with buffer number: " .. bufnr)
    terminals[num] = bufnr
  end
end

return {
  {
    "ThePrimeagen/harpoon",
    -- overwrite default key maps
    keys = function()
      return {
        {
          -- "<leader>na",
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Mark file with harpoon",
        },
        {
          -- "<leader>no",
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Show harpoon marks",
        },
        {
          "<A-j>",
          function()
            require("harpoon"):list():select(1)
          end,
          desc = "Navigate to file 1",
        },
        {
          "<A-k>",
          function()
            require("harpoon"):list():select(2)
          end,
          desc = "Navigate to file 2",
        },
        {
          "<A-l>",
          function()
            require("harpoon"):list():select(3)
          end,
          desc = "Navigate to file 3",
        },
        {
          "<A-;>",
          function()
            require("harpoon"):list():select(4)
          end,
          desc = "Navigate to file 4",
        },
        {
          "<A-h>",
          function()
            open_terminal(1)
          end,
          desc = "Navigate to terminal 1",
        },
        {
          "<A-n>",
          function()
            open_terminal(2)
          end,
          desc = "Navigate to terminal 2",
        },
        {
          "<A-m>",
          function()
            open_terminal(2)
          end,
          desc = "Navigate to terminal 3",
        },
      }
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "<leader>fe",
        "<cmd>Oil<cr>",
        desc = "File Browser (cwd)",
      },
      {
        "<leader>fE",
        function()
          require("oil").open(LazyVim.root())
        end,
        desc = "File Explorer (root)",
      },
      { "<leader>e", "<leader>fe", desc = "File Explorer (cwd)", remap = true },
      { "<leader>E", "<leader>fE", desc = "File Explorer (root)", remap = true },
    },
    opts = {
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
        ["<C-p>"] = false,
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = false,
        ["<leader>nr"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      lsp_file_methods = {
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = true,
      },
      -- Set to true to watch the filesystem for changes and reload oil
      -- experimental_watch_for_changes = true,
    },
  },
  -- Use gx to open links or references in the browser
  {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "v" }, desc = "Open identifier under cursor" },
    },
    opts = {
      handlers = {
        jira = {
          name = "jira",
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "%s(%u+-%d+)%s")
            if ticket and #ticket < 20 then
              return "http://jira.redbullmediahouse.com/browse/" .. ticket
            end
          end,
        },
      },
    },
  },
}
