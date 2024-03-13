return {

  {
    "echasnovski/mini.surround",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = "VeryLazy",
    opts = function()
      return {
        -- Add custom surroundings to be used on top of builtin ones. For more
        -- information with examples, see `:h MiniSurround.config`.
        custom_surroundings = nil,
        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 500,
        -- Number of lines within which surrounding is searched
        n_lines = 20,
        -- Whether to disable showing non-error feedback
        silent = false,
      }
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    version = false,
    lazy = false,
    build = ":TSUpdate",
    opts = {
      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      highlight = { enable = true },
      indent = { enable = false },
      ensure_installed = {
        "bash",
        "html",
        "json",
        "dockerfile",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "yaml",
        "csv",
        "tsv",
        "xml",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aC"] = "@comment.outer",
            ["iC"] = "@comment.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]C"] = "@comment.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]C"] = "@comment.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[C"] = "@comment.outer",
          },
          goto_previous_end = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[C"] = "@comment.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
  },
}
