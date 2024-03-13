local function open_terminal()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buffer):find("^term://") ~= nil then
      vim.api.nvim_win_set_buf(0, buffer)
      return
    end
  end
  vim.cmd(":terminal")
end

local function open_notes() end

---@type Harpoon
local harpoon

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = { name = "+harpoon" },
      },
    },
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
        "<leader>ha",
        function() harpoon:list():append() end,
        desc = "Mark file with harpoon",
      },
      {
        "<leader>ho",
        function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        desc = "Show harpoon marks",
      },
      {
        "<A-h>",
        function() harpoon:list():select(1) end,
        desc = "Navigate to file 1",
      },
      {
        "<A-j>",
        function() harpoon:list():select(2) end,
        desc = "Navigate to file 2",
      },
      {
        "<A-k>",
        function() harpoon:list():select(3) end,
        desc = "Navigate to file 3",
      },
      {
        "<A-l>",
        function() harpoon:list():select(4) end,
        desc = "Navigate to file 4",
      },
      {
        "<A-;>",
        open_terminal,
        desc = "Navigate terminal",
      },
    },
    ---@type HarpoonPartialConfig
    opts = {},
    config = function(_, opts) harpoon = require("harpoon"):setup(opts) end,
  },
}
