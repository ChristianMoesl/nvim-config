---@param filenames string[]
local function extract_filenames(filenames)
  local shortened = {}

  local counts = {}
  for _, file in ipairs(filenames) do
    local name = vim.fn.fnamemodify(file, ":t")
    counts[name] = (counts[name] or 0) + 1
  end

  for _, file in ipairs(filenames) do
    local name = vim.fn.fnamemodify(file, ":t")

    if counts[name] == 1 then
      table.insert(shortened, vim.fn.fnamemodify(name, ":t"))
    else
      table.insert(shortened, file)
    end
  end

  return shortened
end

local function dirname() return extract_filenames({ vim.fn.getcwd() })[1] end

-- define function and formatting of the information
local function parrot_status()
  local status_info = require("parrot.config").get_status_info()
  local status = ""
  if status_info.is_chat then
    status = status_info.prov.chat.name
  else
    status = status_info.prov.command.name
  end
  return string.format("%s(%s)", status, status_info.model)
end

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    ---@type LazyKeysSpec[]
    keys = {
      {
        "<leader>ud",
        "<cmd>Noice dismiss<cr>",
        desc = "Dismiss notifications",
      },
      {
        "<leader>sN",
        "<cmd>Noice telescope<cr>",
        desc = "Notification",
      },
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        desc = "Redirect Cmdline",
        mode = "c",
      },
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- install languages for syntax highlighting in CMD line
      -- https://github.com/folke/noice.nvim#%EF%B8%8F-requirements
      ensure_installed = {
        "vim",
        "regex",
        "lua",
        "bash",
        "markdown",
      },
    },
  },
  -- which-key helps you remember key bindings by showing a popup
  -- with the active keybindings of the command you started typing.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      local defaults = vim.list_extend(opts.defaults, {
        mode = { "n", "v" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "]", group = "next" },
        { "[", group = "prev" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics" },
      })
      defaults.mode = { "n", "v" }

      wk.add(defaults)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "catppuccin/nvim",
    },
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      theme = "catppuccin",
      extensions = {
        "lazy",
        "mason",
        "fugitive",
        "quickfix",
        "nvim-dap-ui",
      },
      sections = {
        lualine_a = {
          "mode",
          dirname,
        },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
          {
            function()
              local marks = require("harpoon"):list():display()
              return table.concat(extract_filenames(marks), " | ")
            end,
            icon = "󰛢",
            on_click = function()
              local harpoon = require("harpoon")
              harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
          },
          "markdown_inline",
        },
        lualine_x = {
          "encoding",
          parrot_status,
        },
      },
    },
  },
}
