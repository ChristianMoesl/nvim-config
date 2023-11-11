local function extract_filenames(filenames)
  local shortened = {}

  local counts = {}
  for _, file in ipairs(filenames) do
    local name = vim.fn.fnamemodify(file.filename, ":t")
    counts[name] = (counts[name] or 0) + 1
  end

  for _, file in ipairs(filenames) do
    local name = vim.fn.fnamemodify(file.filename, ":t")

    if counts[name] == 1 then
      table.insert(shortened, vim.fn.fnamemodify(name, ":t"))
    else
      table.insert(shortened, file.filename)
    end
  end

  return shortened
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
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          -- ["cmp.entry.get_documentation"] = true,
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
      -- install langauges for syntax highlighting in CMD line
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
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gs"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "ThePrimeagen/harpoon",
      "catppuccin/nvim",
    },
    event = "VeryLazy",
    cond = require("christianmoesl.util").is_full_profile,
    opts = {
      extensions = {
        "lazy",
        "mason",
        "fugitive",
        "quickfix",
        "nvim-dap-ui",
      },
      sections = {
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
          {
            function()
              local marks = require("harpoon").get_mark_config().marks
              return table.concat(extract_filenames(marks), " | ")
            end,
            icon = "󰛢",
            on_click = function() require("harpoon.ui").toggle_quick_menu() end,
          },
          "markdown_inline",
        },
      },
    },
  },
}