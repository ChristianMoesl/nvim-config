local function extract_path(terminal_buffer_name)
  local without_prefix = string.sub(terminal_buffer_name, string.len("term://") + 1)

  return string.sub(without_prefix, 1, without_prefix:find("//") - 1)
end

local function open_terminal()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buffer)
    if name:find("^term://") ~= nil then
      local path = extract_path(name)
      local absolute_path = vim.fn.expand(path)

      if absolute_path == vim.fn.getcwd() then
        vim.api.nvim_win_set_buf(0, buffer)
      end
    end
  end
  vim.cmd(":terminal")
end

---@type Harpoon
local harpoon

return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults = vim.list_extend(opts.defaults or {}, {
        { "<leader>n", group = "navigation" },
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>na",
        function() harpoon:list():add() end,
        desc = "Mark file with harpoon",
      },
      {
        "<leader>no",
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        desc = "Show harpoon marks",
      },
      {
        "<A-j>",
        function() harpoon:list():select(1) end,
        desc = "Navigate to file 1",
      },
      {
        "<A-k>",
        function() harpoon:list():select(2) end,
        desc = "Navigate to file 2",
      },
      {
        "<A-l>",
        function() harpoon:list():select(3) end,
        desc = "Navigate to file 3",
      },
      {
        "<A-;>",
        function() harpoon:list():select(4) end,
        desc = "Navigate to file 4",
      },
      {
        "<A-h>",
        open_terminal,
        desc = "Navigate to terminal",
      },
    },
    ---@type HarpoonPartialConfig
    opts = {},
    config = function(_, opts) harpoon = require("harpoon"):setup(opts) end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "<leader>fb",
        "<cmd>Oil<cr>",
        desc = "File Browser",
      },
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
}
